import 'package:admin/utils/const.dart';
import 'package:admin/utils/spacing.dart';
import 'package:flutter/material.dart';

class LightItem extends StatelessWidget {
  const LightItem({
    super.key,
    required this.isReady,
    required this.isGoodLift,
    required this.variation,
  });

  final bool isReady;
  final bool? isGoodLift;
  final int? variation;

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate sizes based on screen width
    // For the main circle, we'll use 20% of screen width, but cap it at 200
    final mainSize = (screenWidth * 0.2).clamp(100.0, 200.0);

    // Other elements will scale proportionally
    final indicatorSize = (mainSize * 0.1).clamp(10.0, 20.0);
    final variationWidth = (mainSize * 0.3).clamp(30.0, 60.0);
    final variationHeight = (mainSize * 0.2).clamp(20.0, 40.0);

    return Column(
      children: [
        Container(
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
            color: isReady ? Colors.white : Colors.grey[900],
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const SizedBox(
          height: defaultSpacing,
        ),
        Container(
          width: mainSize,
          height: mainSize,
          decoration: BoxDecoration(
            color: isGoodLift == null
                ? Colors.grey[900]
                : isGoodLift == true
                    ? Colors.white
                    : Colors.red,
            borderRadius: BorderRadius.circular(mainSize / 2),
          ),
        ),
        const SizedBox(
          height: defaultSpacing,
        ),
        Container(
          width: variationWidth,
          height: variationHeight,
          decoration: BoxDecoration(
            color: variation == null ||
                    variation == whiteValue ||
                    variation == redValue
                ? Colors.grey[900]
                : Color(variation!),
          ),
        ),
      ],
    );
  }
}
