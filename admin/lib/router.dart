import 'package:admin/views/home/home.dart';
import 'package:admin/views/lights/lights.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const String homeRoute = '/';
const String lightsRoute = '/lights';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: homeRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const Home();
      },
    ),
    GoRoute(
      path: lightsRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const Lights();
      },
    ),
  ],
);
