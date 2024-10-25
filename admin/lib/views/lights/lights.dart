import 'package:admin/models/light.dart';
import 'package:admin/providers/meet.dart';
import 'package:admin/providers/screen.dart';
import 'package:admin/router.dart';
import 'package:admin/utils/const.dart';
import 'package:admin/utils/spacing.dart';
import 'package:admin/views/lights/info.dart';
import 'package:admin/views/lights/item.dart';
import 'package:admin/views/lights/judge_notif.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Lights extends ConsumerWidget {
  const Lights({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFullScreen = ref.watch(frameLessProvider);
    final lights = ref.watch(meetProvider).lights;
    final screenWidth = MediaQuery.of(context).size.width;

    Light? side1Light =
        lights.firstWhereOrNull((light) => light.judgeRole == sideJudge1);
    Light? side2Light =
        lights.firstWhereOrNull((light) => light.judgeRole == sideJudge2);
    Light? headLight =
        lights.firstWhereOrNull((light) => light.judgeRole == headJudge);

    bool isAllLightsReady =
        side1Light != null && side2Light != null && headLight != null;

    // Calculate spacing based on screen width
    final horizontalSpacing =
        (screenWidth * 0.05).clamp(10.0, defaultSpacing * 2);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: isFullScreen
          ? null
          : AppBar(
              backgroundColor: Colors.black,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
      drawer: !isFullScreen
          ? Drawer(
              backgroundColor: Colors.black,
              width: 300,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(defaultSpacing),
                  child: Column(
                    children: [
                      MeetInfo(),
                      const Divider(color: Colors.white),
                      const SizedBox(height: defaultSpacing),
                      ...(ref.watch(meetProvider).judges.map((judge) {
                        return JudgeNotif(
                          title: judge.role,
                          onRemove: () {
                            ref
                                .read(meetProvider.notifier)
                                .removeJudge(judge.id);
                          },
                        );
                      }).toList()),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(meetProvider.notifier).exitMeet();
                          GoRouter.of(context).replace(homeRoute);
                        },
                        style: ButtonStyle(
                          minimumSize: const MaterialStatePropertyAll(
                            Size(double.infinity, 50),
                          ),
                          shape: const MaterialStatePropertyAll(
                            RoundedRectangleBorder(),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.error,
                          ),
                          foregroundColor: const MaterialStatePropertyAll(
                            Colors.white,
                          ),
                        ),
                        child: const Text('Exit'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: defaultSpacing * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LightItem(
                    isReady: side1Light != null,
                    isGoodLift: isAllLightsReady
                        ? side1Light.value == whiteValue
                        : null,
                    variation: isAllLightsReady ? side1Light.value : null,
                  ),
                  SizedBox(width: horizontalSpacing),
                  LightItem(
                    isReady: headLight != null,
                    isGoodLift:
                        isAllLightsReady ? headLight.value == whiteValue : null,
                    variation: isAllLightsReady ? headLight.value : null,
                  ),
                  SizedBox(width: horizontalSpacing),
                  LightItem(
                    isReady: side2Light != null,
                    isGoodLift: isAllLightsReady
                        ? side2Light.value == whiteValue
                        : null,
                    variation: isAllLightsReady ? side2Light.value : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(meetProvider.notifier).resetLight();
        },
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
