import 'package:admin/router.dart';
import 'package:admin/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(defaultSpacing),
        child: Center(
          child: SizedBox(
            width: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Meet ID',
                  ),
                  onChanged: (value) {},
                ),
                spacing(double.infinity, defaultSpacing),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  onChanged: (value) {},
                ),
                spacing(double.infinity, defaultSpacing),
                CheckboxListTile(
                  title: const Text('Enable blue and yellow colors'),
                  value: false,
                  onChanged: (value) {},
                ),
                spacing(double.infinity, defaultSpacing),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).replace(lightsRoute);
                  },
                  style: ButtonStyle(
                    minimumSize: const WidgetStatePropertyAll(
                      Size(double.infinity, 50),
                    ),
                    shape: const WidgetStatePropertyAll(
                      RoundedRectangleBorder(),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primary,
                    ),
                    foregroundColor: const WidgetStatePropertyAll(
                      Colors.white,
                    ),
                  ),
                  child: const Text('Launch Meet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
