import 'package:admin/providers/meet.dart';
import 'package:admin/router.dart';
import 'package:admin/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    ref.read(meetProvider.notifier).checkUnclosedMeet().then((exist) {
      if (exist) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Info'),
              content: const Text('Resume the previous meet ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(meetProvider.notifier).resumeMeet();
                    GoRouter.of(context).replace(lightsRoute);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

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
                  onChanged: (value) {
                    ref.read(meetProvider.notifier).setName(value);
                  },
                ),
                spacing(double.infinity, defaultSpacing),
                CheckboxListTile(
                  title: const Text('Enable blue and yellow colors'),
                  value: ref.watch(meetProvider).enableOtherLightColors,
                  onChanged: (value) {
                    ref
                        .read(meetProvider.notifier)
                        .setEnableOtherLightColors(value ?? false);
                  },
                ),
                spacing(double.infinity, defaultSpacing),
                ElevatedButton(
                  onPressed: ref.watch(meetProvider).loading
                      ? null
                      : () {
                          ref.read(meetProvider.notifier).setLoading(true);
                          ref.read(meetProvider.notifier).saveMeet();
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
                  child: const Text('Start Meet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
