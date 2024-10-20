import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lights/providers/meet.dart';
import 'package:lights/services/services.dart';

class ServerState {
  final ServerConnection? connection;

  ServerState({
    this.connection,
  });
}

final serverProvider = StateNotifierProvider<ServerNotifier, ServerState>(
  (ref) => ServerNotifier(ref),
);

class ServerNotifier extends StateNotifier<ServerState> {
  final Ref _ref;

  ServerNotifier(this._ref)
      : super(
          ServerState(),
        );

  void init(String url) {
    state = ServerState(
      connection: ServerConnection(
        url,
        (data) {
          if (data['type'] == 'resetLight') {
            _ref.read(meetProvider.notifier).setWaiting(false);
          }
        },
        () {
          SystemNavigator.pop();
        },
      ),
    );
  }
}
