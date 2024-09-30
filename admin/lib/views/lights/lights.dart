import 'package:admin/providers/meet.dart';
import 'package:admin/providers/screen.dart';
import 'package:admin/router.dart';
import 'package:admin/utils/const.dart';
import 'package:admin/utils/spacing.dart';
import 'package:admin/views/lights/info.dart';
import 'package:admin/views/lights/item.dart';
import 'package:admin/views/lights/judge_notif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Lights extends ConsumerWidget {
  const Lights({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFullScreen = ref.watch(frameLessProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            isFullScreen
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: 300,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(defaultSpacing),
                    child: Column(
                      children: [
                        isFullScreen ? Container() : MeetInfo(),
                        const Divider(),
                        const SizedBox(
                          height: defaultSpacing,
                        ),
                        const JudgeNotif(title: 'Head Judge Joined'),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(meetProvider.notifier).exitMeet();
                            GoRouter.of(context).replace(homeRoute);
                          },
                          style: ButtonStyle(
                            minimumSize: const WidgetStatePropertyAll(
                              Size(double.infinity, 50),
                            ),
                            shape: const WidgetStatePropertyAll(
                              RoundedRectangleBorder(),
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.error,
                            ),
                            foregroundColor: const WidgetStatePropertyAll(
                              Colors.white,
                            ),
                          ),
                          child: const Text('Exit'),
                        ),
                      ],
                    ),
                  ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LightItem(
                        isReady: true,
                        isGoodLift: true,
                        variation: null,
                      ),
                      SizedBox(
                        width: defaultSpacing * 2,
                      ),
                      LightItem(
                        isReady: false,
                        isGoodLift: null,
                        variation: null,
                      ),
                      SizedBox(
                        width: defaultSpacing * 2,
                      ),
                      LightItem(
                        isReady: true,
                        isGoodLift: false,
                        variation: blue,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: defaultSpacing * 4,
                  ),
                  isFullScreen
                      ? Container()
                      : SizedBox(
                          width: 200,
                          child: OutlinedButton(
                            onPressed: () {
                              ref
                                  .read(frameLessProvider.notifier)
                                  .setFrameLess(true);
                            },
                            style: const ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(),
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.fullscreen),
                                Text('Full Screen'),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
