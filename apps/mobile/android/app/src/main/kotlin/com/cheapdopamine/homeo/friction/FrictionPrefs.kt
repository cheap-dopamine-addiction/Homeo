package com.cheapdopamine.homeo.friction

import android.content.Context
import android.content.SharedPreferences
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Everything native shares with Dart lives in `FlutterSharedPreferences`,
 * keys carry Flutter's `flutter.` prefix so the Dart `shared_preferences`
 * package sees the same file.
 *
 * Used from the accessibility service thread and from MainActivity, so every
 * read-modify-write is @Synchronized.
 */
object FrictionPrefs {
    const val PREFS_NAME = "FlutterSharedPreferences"
    const val KEY_BLOCKED = "flutter.blocked_packages"

    private const val KEY_PENDING = "flutter.pending_distraction_events"
    private const val KEY_ALLOW_ALL_UNTIL = "flutter.allow_all_until"
    private const val KEY_ALLOW_PREFIX = "flutter.allow_until."
    private const val KEY_COUNT_PREFIX = "flutter.open_count."
    private const val MAX_PENDING = 500

    // Dart's setStringList() stores lists as "<this prefix>!<json>".
    private const val LIST_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu!"

    fun prefs(ctx: Context): SharedPreferences =
        ctx.applicationContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    // ── Watch list ───────────────────────────────────────────────────────────

    fun readBlocked(ctx: Context): Set<String> {
        val raw = prefs(ctx).getString(KEY_BLOCKED, null) ?: return emptySet()
        val json = if (raw.startsWith(LIST_PREFIX)) raw.removePrefix(LIST_PREFIX) else raw
        return try {
            val array = JSONArray(json)
            (0 until array.length()).map { array.getString(it) }.toSet()
        } catch (e: Exception) {
            emptySet()
        }
    }

    fun writeBlocked(ctx: Context, packages: List<String>) {
        prefs(ctx).edit().putString(KEY_BLOCKED, JSONArray(packages).toString()).apply()
    }

    // ── Pending events (imported into Drift by Dart) ─────────────────────────

    @Synchronized
    fun appendPending(ctx: Context, packageName: String, timestampMs: Long) {
        val current = readPendingArray(ctx)
        current.put(JSONObject().put("app", packageName).put("ts", timestampMs))

        val trimmed = if (current.length() > MAX_PENDING) {
            JSONArray().also { out ->
                for (i in current.length() - MAX_PENDING until current.length()) {
                    out.put(current.get(i))
                }
            }
        } else current

        prefs(ctx).edit().putString(KEY_PENDING, trimmed.toString()).commit()
    }

    /** Returns `[{app, ts}]` without removing anything (ack removes). */
    @Synchronized
    fun peekPending(ctx: Context): List<Map<String, Any>> {
        val array = readPendingArray(ctx)
        val out = ArrayList<Map<String, Any>>(array.length())
        for (i in 0 until array.length()) {
            val item = array.optJSONObject(i) ?: continue
            val app = item.optString("app", "")
            val ts = item.optLong("ts", 0L)
            if (app.isNotEmpty() && ts > 0L) out.add(mapOf("app" to app, "ts" to ts))
        }
        return out
    }

    /** Drops every event with `ts <= upTo`. */
    @Synchronized
    fun ackPending(ctx: Context, upTo: Long) {
        val array = readPendingArray(ctx)
        val kept = JSONArray()
        for (i in 0 until array.length()) {
            val item = array.optJSONObject(i) ?: continue
            if (item.optLong("ts", 0L) > upTo) kept.put(item)
        }
        prefs(ctx).edit().putString(KEY_PENDING, kept.toString()).commit()
    }

    private fun readPendingArray(ctx: Context): JSONArray {
        val raw = prefs(ctx).getString(KEY_PENDING, null) ?: return JSONArray()
        return try { JSONArray(raw) } catch (e: Exception) { JSONArray() }
    }

    // ── Per-day open counter ("time N today") ────────────────────────────────

    @Synchronized
    fun incrementTodayCount(ctx: Context, packageName: String): Int {
        val p = prefs(ctx)
        val today = SimpleDateFormat("yyyyMMdd", Locale.US).format(Date())
        val todayPrefix = "$KEY_COUNT_PREFIX$today."
        val key = "$todayPrefix$packageName"
        val next = p.getLong(key, 0L) + 1

        val edit = p.edit().putLong(key, next)
        // Forget other days so this never grows.
        p.all.keys
            .filter { it.startsWith(KEY_COUNT_PREFIX) && !it.startsWith(todayPrefix) }
            .forEach { edit.remove(it) }
        edit.apply()
        return next.toInt()
    }

    // ── Muting (emergency / "open anyway" windows from Dart) ─────────────────

    /** [packageName] == null mutes every app. */
    fun setAllowUntil(ctx: Context, packageName: String?, untilMs: Long) {
        val key = if (packageName == null) KEY_ALLOW_ALL_UNTIL else "$KEY_ALLOW_PREFIX$packageName"
        prefs(ctx).edit().putLong(key, untilMs).apply()
    }

    fun isMuted(ctx: Context, packageName: String, nowMs: Long): Boolean {
        val p = prefs(ctx)
        return nowMs < p.getLong(KEY_ALLOW_ALL_UNTIL, 0L) ||
            nowMs < p.getLong("$KEY_ALLOW_PREFIX$packageName", 0L)
    }
}
