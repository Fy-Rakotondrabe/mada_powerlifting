import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LightScreen extends StatelessWidget {
  const LightScreen({super.key});

  final bool enableOtherLight = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randori'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double containerHeight = constraints.maxHeight / 2;
          return Column(
            children: [
              !enableOtherLight
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
              enableOtherLight
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
