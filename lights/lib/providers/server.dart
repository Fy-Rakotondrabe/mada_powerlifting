import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lights/services/services.dart';

class ServerState {
  final ServerConnection? connection;

  ServerState({
    this.connection,
  });
}

final serverProvider = StateNotifierProvider<ServerNotifier, ServerState>(
  (ref) => ServerNotifier(),
);

class ServerNotifier extends StateNotifier<ServerState> {
  ServerNotifier()
      : super(
          ServerState(),
        );

  void init(String url, BuildContext context) {
    state = ServerState(
      connection: ServerConnection(
        url,
        (data) {
          log(data.toString());
        },
        () {
          SystemNavigator.pop();
        },
      ),
    );
  }
}
