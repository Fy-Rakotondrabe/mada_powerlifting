import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lights/model/judge.dart';
import 'package:lights/model/meet.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class MeetState {
  final Meet? currentMeet;
  final Judge? judge;

  final bool loading;
  final bool waiting;

  MeetState({
    this.judge,
    this.currentMeet,
    this.loading = false,
    this.waiting = false,
  });

  MeetState copyWith({
    Judge? judge,
    Meet? currentMeet,
    bool? loading,
    bool? waiting,
  }) {
    return MeetState(
      judge: judge ?? this.judge,
      currentMeet: currentMeet ?? this.currentMeet,
      loading: loading ?? this.loading,
      waiting: waiting ?? this.waiting,
    );
  }
}

final meetProvider = StateNotifierProvider<MeetNotifier, MeetState>(
  (ref) => MeetNotifier(),
);

class MeetNotifier extends StateNotifier<MeetState> {
  MeetNotifier()
      : super(
          MeetState(),
        );

  Future<void> exitMeet() async {}

  void setLoading(bool loading) {
    state = state.copyWith(loading: loading);
  }

  void setWaiting(bool loading) {
    state = state.copyWith(waiting: loading);
  }

  void setJudge(String role) {
    state = state.copyWith(judge: Judge(role: role, id: uuid.v4()));
  }

  void setCurrentMeet(Meet meet) {
    state = state.copyWith(currentMeet: meet);
  }
}
