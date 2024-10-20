import 'dart:developer';

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
    log(variation.toString());
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
