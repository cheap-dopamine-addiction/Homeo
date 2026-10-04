-- Homeo — Core Database Schema (PostgreSQL)
-- Mirrors the ERD and indexing strategy in PRD §16.

CREATE EXTENSION IF NOT EXISTS "pgcrypto"; -- gen_random_uuid()

CREATE TYPE auth_provider AS ENUM ('email', 'google', 'apple');
CREATE TYPE focus_session_status AS ENUM ('active', 'completed', 'aborted');
CREATE TYPE distraction_resolved_action AS ENUM (
  'returned_to_focus', 'opened_anyway', 'partner_approved', 'emergency_override'
);
CREATE TYPE vault_partnership_status AS ENUM ('pending', 'active', 'revoked');
CREATE TYPE vault_approval_rule AS ENUM ('any_partner', 'all_partners');
CREATE TYPE override_request_status AS ENUM (
  'pending', 'approved', 'denied', 'expired_auto_released'
);

CREATE TABLE users (
  id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email                    TEXT UNIQUE NOT NULL,
  display_name             TEXT NOT NULL,
  auth_provider            auth_provider NOT NULL,
  created_at               TIMESTAMPTZ NOT NULL DEFAULT now(),
  timezone                 TEXT NOT NULL,             -- IANA tz name
  onboarding_completed_at  TIMESTAMPTZ,
  deleted_at               TIMESTAMPTZ                -- soft delete
);

CREATE TABLE focus_sessions (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  intention             TEXT NOT NULL,
  planned_duration_sec  INT NOT NULL,
  actual_duration_sec   INT,
  status                focus_session_status NOT NULL DEFAULT 'active',
  started_at            TIMESTAMPTZ NOT NULL,
  ended_at              TIMESTAMPTZ,
  local_id              UUID NOT NULL,                -- client-generated id, offline dedup (PRD §21-22)
  synced_at             TIMESTAMPTZ
);

CREATE TABLE distraction_events (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  app_package_id   TEXT NOT NULL,
  friction_level   SMALLINT NOT NULL CHECK (friction_level BETWEEN 0 AND 4), -- L0-L4
  resolved_action  distraction_resolved_action NOT NULL,
  occurred_at      TIMESTAMPTZ NOT NULL
);

CREATE TABLE vault_partnerships (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  partner_user_id   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status            vault_partnership_status NOT NULL DEFAULT 'pending',
  permission_scope  JSONB NOT NULL DEFAULT '{}',       -- granular visibility flags
  approval_rule     vault_approval_rule NOT NULL DEFAULT 'any_partner',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  revoked_at        TIMESTAMPTZ,
  CHECK (owner_user_id <> partner_user_id)
);

CREATE TABLE override_requests (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  partnership_id        UUID NOT NULL REFERENCES vault_partnerships(id) ON DELETE CASCADE,
  requested_by_user_id  UUID NOT NULL REFERENCES users(id),
  app_package_id        TEXT NOT NULL,
  reason_text           TEXT NOT NULL,
  status                override_request_status NOT NULL DEFAULT 'pending',
  requested_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  resolved_at           TIMESTAMPTZ,
  resolved_by_user_id   UUID REFERENCES users(id)
);

CREATE TABLE habit_goals (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title         TEXT NOT NULL,
  target_type   TEXT NOT NULL CHECK (target_type IN ('streak', 'frequency')),
  target_value  INT NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  archived_at   TIMESTAMPTZ
);

CREATE TABLE blocked_apps (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  app_package_id  TEXT NOT NULL,
  friction_level  SMALLINT NOT NULL CHECK (friction_level BETWEEN 0 AND 4),
  active_hours    JSONB NOT NULL DEFAULT '{}',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, app_package_id)
);

CREATE TABLE reflection_entries (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  session_id     UUID REFERENCES focus_sessions(id) ON DELETE SET NULL,
  prompt_key     TEXT NOT NULL,
  response_text  TEXT,                                 -- application-level encrypted (AES-256-GCM), PRD §23.2
  mood_tag       TEXT,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE user_settings (
  user_id                              UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  default_friction_level               SMALLINT NOT NULL DEFAULT 1 CHECK (default_friction_level BETWEEN 0 AND 4),
  quiet_hours                          JSONB NOT NULL DEFAULT '{}',
  locale                               TEXT NOT NULL DEFAULT 'th',
  theme                                TEXT NOT NULL DEFAULT 'system',
  emergency_override_limit_per_month   SMALLINT NOT NULL DEFAULT 3
);

CREATE TABLE analytics_snapshots ( -- daily rollup, materialized for fast dashboard reads
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  date                  DATE NOT NULL,
  total_focus_min       INT NOT NULL DEFAULT 0,
  distraction_count     INT NOT NULL DEFAULT 0,
  dopamine_load_index   NUMERIC(5,2) NOT NULL DEFAULT 0,
  streak_current        INT NOT NULL DEFAULT 0,
  streak_best           INT NOT NULL DEFAULT 0,
  UNIQUE (user_id, date)
);

CREATE TABLE audit_log_entries ( -- append-only, PRD §10.4 "audit immutability"
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_user_id  UUID NOT NULL REFERENCES users(id),
  entity_type    TEXT NOT NULL,
  entity_id      UUID NOT NULL,
  action         TEXT NOT NULL,
  metadata       JSONB NOT NULL DEFAULT '{}',
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexing strategy (PRD §16.3)
CREATE INDEX idx_focus_sessions_user_started        ON focus_sessions (user_id, started_at DESC);
CREATE INDEX idx_distraction_events_user_occurred    ON distraction_events (user_id, occurred_at DESC);
CREATE INDEX idx_override_requests_partnership_status ON override_requests (partnership_id, status);
CREATE INDEX idx_vault_partnerships_owner            ON vault_partnerships (owner_user_id);
CREATE INDEX idx_vault_partnerships_partner          ON vault_partnerships (partner_user_id);

-- Partial index keeps the Vault Partner approval inbox query fast even at scale
CREATE INDEX idx_override_requests_pending ON override_requests (partnership_id)
  WHERE status = 'pending';
