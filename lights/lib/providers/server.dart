import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lights/providers/meet.dart';
import 'package:lights/router.dart';
import 'package:lights/services/services.dart';

class ServerState {
  final ServerConnection? connection;

  ServerState({
    this.connection,
  });
}

final serverProvider =
    StateNotifierProvider<ServerNotifier, ServerState>((ref) {
  final router = ref.watch(routerProvider);
  return ServerNotifier(ref, router);
});

class ServerNotifier extends StateNotifier<ServerState> {
  final Ref _ref;
  final GoRouter router;

  ServerNotifier(this._ref, this.router)
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
        router,
      ),
    );
  }
}
