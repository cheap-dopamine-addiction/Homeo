import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CoachRole { ai, user }

@immutable
class CoachMessage {
  const CoachMessage({
    required this.id,
    required this.role,
    required this.text,
    this.isEdited = false,
    this.isRegenerated = false,
  });

  final String id;
  final CoachRole role;
  final String text;
  final bool isEdited;
  final bool isRegenerated;

  CoachMessage copyWith({String? text, bool? isEdited, bool? isRegenerated}) =>
      CoachMessage(
        id: id,
        role: role,
        text: text ?? this.text,
        isEdited: isEdited ?? this.isEdited,
        isRegenerated: isRegenerated ?? this.isRegenerated,
      );
}

/// A finished conversation kept for the sidebar "History" (this session only —
/// there is no chat backend yet).
@immutable
class CoachConversation {
  const CoachConversation({
    required this.id,
    required this.title,
    required this.messages,
    required this.savedAt,
  });

  final String id;
  final String title;
  final List<CoachMessage> messages;
  final DateTime savedAt;
}

@immutable
class CoachState {
  const CoachState({
    this.messages = const [],
    this.isTyping = false,
    this.activeId,
    this.editingId,
    this.deleteConfirmId,
    this.history = const [],
  });

  final List<CoachMessage> messages;
  final bool isTyping;
  final String? activeId;
  final String? editingId;
  final String? deleteConfirmId;
  final List<CoachConversation> history;

  CoachState copyWith({
    List<CoachMessage>? messages,
    bool? isTyping,
    Object? activeId = _keep,
    Object? editingId = _keep,
    Object? deleteConfirmId = _keep,
    List<CoachConversation>? history,
  }) {
    return CoachState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      activeId: identical(activeId, _keep) ? this.activeId : activeId as String?,
      editingId: identical(editingId, _keep)
          ? this.editingId
          : editingId as String?,
      deleteConfirmId: identical(deleteConfirmId, _keep)
          ? this.deleteConfirmId
          : deleteConfirmId as String?,
      history: history ?? this.history,
    );
  }

  static const Object _keep = Object();
}

/// Produces the coach's answer for a user message. Supplied by the screen so
/// the text can use the current locale and live app data.
typedef CoachReply = String Function(String userText);

/// Chat state for the AI Coach tab (design: `AICoachScreen.tsx`).
///
/// Replies come from a local rule-based responder — no network or model is
/// involved, matching the design's mocked coach. Swap [CoachReply] for a
/// backend call (PRD §18 `/v1/ai-coach/messages`) when it exists.
class AiCoachController extends Notifier<CoachState> {
  final _random = Random();
  int _idCounter = 0;
  Timer? _typingTimer;

  @override
  CoachState build() {
    ref.onDispose(() => _typingTimer?.cancel());
    return const CoachState();
  }

  String _nextId() => '${DateTime.now().microsecondsSinceEpoch}_${_idCounter++}';

  /// Adds the opening greeting once (first time the tab is shown).
  void ensureGreeting(String text) {
    if (state.messages.isEmpty && !state.isTyping) {
      state = state.copyWith(
        messages: [CoachMessage(id: _nextId(), role: CoachRole.ai, text: text)],
      );
    }
  }

  void _reply(String userText, CoachReply reply, {bool regenerated = false}) {
    _typingTimer?.cancel();
    state = state.copyWith(isTyping: true);
    _typingTimer = Timer(
      Duration(milliseconds: 1200 + _random.nextInt(800)),
      () {
        if (!ref.mounted) return;
        final msg = CoachMessage(
          id: _nextId(),
          role: CoachRole.ai,
          text: reply(userText),
          isRegenerated: regenerated,
        );
        state = state.copyWith(
          messages: [...state.messages, msg],
          isTyping: false,
        );
      },
    );
  }

  void send(String text, CoachReply reply) {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isTyping) return;
    state = state.copyWith(
      messages: [
        ...state.messages,
        CoachMessage(id: _nextId(), role: CoachRole.user, text: trimmed),
      ],
      activeId: null,
    );
    _reply(trimmed, reply);
  }

  void toggleActive(String id) {
    if (state.editingId != null) return;
    state = state.copyWith(activeId: state.activeId == id ? null : id);
  }

  void clearActive() {
    if (state.activeId != null) state = state.copyWith(activeId: null);
  }

  void startEdit(String id) =>
      state = state.copyWith(editingId: id, activeId: null);

  void cancelEdit() => state = state.copyWith(editingId: null);

  /// Replaces the edited message, drops everything after it and asks again.
  void sendEdit(String id, String newText, CoachReply reply) {
    final text = newText.trim();
    if (text.isEmpty) return;
    final idx = state.messages.indexWhere((m) => m.id == id);
    if (idx == -1) return;
    final updated = state.messages[idx].copyWith(text: text, isEdited: true);
    state = state.copyWith(
      messages: [...state.messages.sublist(0, idx), updated],
      editingId: null,
    );
    _reply(text, reply);
  }

  void askDelete(String id) =>
      state = state.copyWith(deleteConfirmId: id, activeId: null);

  void cancelDelete() => state = state.copyWith(deleteConfirmId: null);

  void confirmDelete() {
    final id = state.deleteConfirmId;
    if (id == null) return;
    state = state.copyWith(
      messages: [
        for (final m in state.messages)
          if (m.id != id) m,
      ],
      deleteConfirmId: null,
    );
  }

  void regenerate(CoachMessage msg, CoachReply reply) {
    if (state.isTyping) return;
    final idx = state.messages.indexWhere((m) => m.id == msg.id);
    if (idx == -1) return;
    final next = [...state.messages];
    if (idx + 1 < next.length && next[idx + 1].role == CoachRole.ai) {
      next.removeAt(idx + 1);
    }
    state = state.copyWith(messages: next, activeId: null);
    _reply(msg.text, reply, regenerated: true);
  }

  /// Saves the current chat (if the user wrote anything) and starts fresh.
  void newChat(String greeting) {
    _typingTimer?.cancel();
    final firstUser = state.messages
        .where((m) => m.role == CoachRole.user)
        .map((m) => m.text)
        .firstOrNull;
    final history = firstUser == null
        ? state.history
        : [
            CoachConversation(
              id: _nextId(),
              title: firstUser,
              messages: state.messages,
              savedAt: DateTime.now(),
            ),
            ...state.history,
          ];
    state = CoachState(
      history: history,
      messages: [
        CoachMessage(id: _nextId(), role: CoachRole.ai, text: greeting),
      ],
    );
  }

  void openHistory(String id) {
    final convo = state.history.where((c) => c.id == id).firstOrNull;
    if (convo == null) return;
    _typingTimer?.cancel();
    state = CoachState(history: state.history, messages: convo.messages);
  }
}

final aiCoachControllerProvider =
    NotifierProvider<AiCoachController, CoachState>(AiCoachController.new);
