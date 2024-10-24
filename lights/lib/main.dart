import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lights/router.dart';
import 'package:lights/utils/theme.dart';
import 'package:keep_screen_on/keep_screen_on.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KeepScreenOn.turnOn();
  runApp(
    const ProviderScope(
      child: Referee(),
    ),
  );
}

class Referee extends ConsumerWidget {
  const Referee({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Referee',
      theme: themeData,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
