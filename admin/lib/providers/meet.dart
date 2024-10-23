import 'package:admin/db/database_helper.dart';
import 'package:admin/models/judge.dart';
import 'package:admin/models/light.dart';
import 'package:admin/models/meet.dart';
import 'package:admin/utils/const.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeetState {
  final String name;
  final bool enableOtherLightColors;

  final Meet? currentMeet;
  final List<Light> lights;
  final List<Judge> judges;

  final bool loading;

  MeetState({
    required this.name,
    required this.enableOtherLightColors,
    this.currentMeet,
    this.loading = false,
    this.lights = const [],
    this.judges = const [],
  });

  MeetState copyWith({
    String? name,
    bool? enableOtherLightColors,
    Meet? currentMeet,
    bool? loading,
    List<Light>? lights,
    List<Judge>? judges,
    bool? resetCurrentMeet,
  }) {
    return MeetState(
      name: name ?? this.name,
      enableOtherLightColors:
          enableOtherLightColors ?? this.enableOtherLightColors,
      currentMeet:
          resetCurrentMeet == true ? null : (currentMeet ?? this.currentMeet),
      loading: loading ?? this.loading,
      lights: lights ?? this.lights,
      judges: judges ?? this.judges,
    );
  }
}

final meetProvider = StateNotifierProvider<MeetNotifier, MeetState>(
  (ref) => MeetNotifier(),
);

class MeetNotifier extends StateNotifier<MeetState> {
  MeetNotifier()
      : super(
          MeetState(
            name: '',
            enableOtherLightColors: false,
          ),
        );

  final _dbHelper = DatabaseHelper();

  Future<void> saveMeet() async {
    Meet meet = Meet(
      name: state.name,
      enableOtherLightColors: state.enableOtherLightColors,
      startDateTime: DateTime.now(),
    );
    await _dbHelper.insertMeet(meet);
    state = state.copyWith(currentMeet: meet, loading: false);
  }

  Future<bool> checkUnclosedMeet() async {
    final meet = await _dbHelper.checkUnclosedMeet();
    if (meet == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> resumeMeet() async {
    final meet = await _dbHelper.checkUnclosedMeet();
    state = state.copyWith(currentMeet: meet);
  }

  Future<void> exitMeet() async {
    Meet meet = state.currentMeet!;
    meet = meet.copyWith(exitDateTime: DateTime.now());
    await _dbHelper.updateMeet(meet);
    state = state.copyWith(currentMeet: null, resetCurrentMeet: true);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setEnableOtherLightColors(bool enableOtherLightColors) {
    state = state.copyWith(enableOtherLightColors: enableOtherLightColors);
  }

  void setLoading(bool loading) {
    state = state.copyWith(loading: loading);
  }

  void addJudge(Judge judge) {
    if (state.currentMeet != null) {
      state = state.copyWith(judges: [...state.judges, judge]);
    }
  }

  void removeJudge(String id) {
    state = state.copyWith(
      judges: state.judges.where((j) => j.id != id).toList(),
    );
  }

  void addLight(Light light) {
    state = state.copyWith(lights: [...state.lights, light]);
  }

  void resetLight() {
    state = state.copyWith(lights: []);
  }
}
