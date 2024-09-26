import 'package:admin/providers/screen.dart';
import 'package:admin/router.dart';
import 'package:admin/utils/const.dart';
import 'package:admin/utils/spacing.dart';
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
                        const JudgeNotif(title: 'Head Judge Joined'),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
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

class JudgeNotif extends StatelessWidget {
  const JudgeNotif({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(defaultSpacing / 2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultSpacing),
        ),
        color: Colors.grey[900],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 40,
          ),
          const SizedBox(
            width: defaultSpacing,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

class LightItem extends StatelessWidget {
  const LightItem({
    super.key,
    required this.isReady,
    required this.isGoodLift,
    required this.variation,
  });

  final bool isReady;
  final bool? isGoodLift;
  final String? variation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isReady ? Colors.white : Colors.grey[900],
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const SizedBox(
          height: defaultSpacing,
        ),
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: isGoodLift == null
                ? Colors.grey[900]
                : isGoodLift == true
                    ? Colors.white
                    : Colors.red,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const SizedBox(
          height: defaultSpacing,
        ),
        Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            color: variation == blue
                ? Colors.blue
                : variation == yellow
                    ? Colors.yellow
                    : Colors.grey[900],
          ),
        ),
      ],
    );
  }
}
