import 'package:admin/utils/spacing.dart';
import 'package:flutter/material.dart';

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
