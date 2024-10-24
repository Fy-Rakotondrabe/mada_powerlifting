import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lights/views/lights.dart';
import 'package:lights/views/scan.dart';

const String scanRoute = '/';
const String rolesRoute = '/roles';
const String lightsRoute = '/lights';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: scanRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const ScanScreen();
        },
      ),
      GoRoute(
        path: lightsRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const LightScreen();
        },
      ),
    ],
  );
});
