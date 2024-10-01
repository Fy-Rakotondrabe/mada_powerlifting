import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lights/router.dart';
import 'package:lights/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: Referee(),
    ),
  );
}

class Referee extends StatelessWidget {
  const Referee({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Referee',
      theme: themeData,
      routerConfig: router,
    );
  }
}
