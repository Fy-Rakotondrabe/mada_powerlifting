import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lights/providers/meet.dart';

class LightScreen extends ConsumerWidget {
  const LightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.watch(meetProvider).currentMeet?.name ?? ''),
      ),
      body: LayoutBuilder(
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
                        ),
                        _buildContainer(
                          Colors.red,
                          constraints.maxWidth,
                          containerHeight,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        _buildContainer(
                          Colors.white,
                          constraints.maxWidth / 2,
                          containerHeight,
                        ),
                        _buildContainer(
                          Colors.red,
                          constraints.maxWidth / 2,
                          containerHeight,
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
                        ),
                        _buildContainer(
                          Colors.yellow,
                          constraints.maxWidth / 2,
                          containerHeight,
                        ),
                      ],
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContainer(Color color, double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onLongPress: () {
          HapticFeedback.heavyImpact();
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
