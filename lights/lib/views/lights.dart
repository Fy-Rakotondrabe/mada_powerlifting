import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lights/model/judge.dart';
import 'package:lights/model/light.dart';
import 'package:lights/providers/meet.dart';
import 'package:lights/providers/server.dart';

class LightScreen extends ConsumerWidget {
  const LightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.watch(meetProvider).currentMeet?.name ?? ''),
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final double containerHeight = constraints.maxHeight / 2;
              return Column(
                children: [
                  ref.watch(meetProvider).currentMeet?.enableOtherLightColors ==
                          false
                      ? Column(
                          children: [
                            _buildContainer(
                              Colors.white,
                              constraints.maxWidth,
                              containerHeight,
                              context,
                              ref,
                            ),
                            _buildContainer(
                              Colors.red,
                              constraints.maxWidth,
                              containerHeight,
                              context,
                              ref,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            _buildContainer(
                              Colors.white,
                              constraints.maxWidth / 2,
                              containerHeight,
                              context,
                              ref,
                            ),
                            _buildContainer(
                              Colors.red,
                              constraints.maxWidth / 2,
                              containerHeight,
                              context,
                              ref,
                            ),
                          ],
                        ),
                  ref.watch(meetProvider).currentMeet?.enableOtherLightColors ==
                          true
                      ? Row(
                          children: [
                            _buildContainer(
                              Colors.blue,
                              constraints.maxWidth / 2,
                              containerHeight,
                              context,
                              ref,
                            ),
                            _buildContainer(
                              Colors.yellow,
                              constraints.maxWidth / 2,
                              containerHeight,
                              context,
                              ref,
                            ),
                          ],
                        )
                      : Container(),
                ],
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final isWaiting = ref.watch(meetProvider).waiting;
              if (isWaiting) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const PopScope(
                        child: AlertDialog(
                          title: Text('Sent'),
                          content: Text('Waiting for the next athlete...'),
                        ),
                      );
                    },
                  );
                });
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (Navigator.of(context, rootNavigator: true).canPop()) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                });
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContainer(Color color, double width, double height,
      BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onLongPress: () {
          HapticFeedback.heavyImpact();
          try {
            Judge? judge = ref.watch(meetProvider).judge;
            if (judge != null) {
              ref.read(serverProvider).connection?.postLight(
                    Light(judgeRole: judge.role, value: color.value),
                  );
              ref.read(meetProvider.notifier).setWaiting(true);
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Failed to post light'),
              ),
            );
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            color: color,
          ),
        ),
      ),
    );
  }
}
