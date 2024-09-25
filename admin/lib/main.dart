import 'package:admin/router.dart';
import 'package:admin/utils/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Admin());
}

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeData,
      routerConfig: router,
    );
  }
}
