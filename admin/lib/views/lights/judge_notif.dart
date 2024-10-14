import 'package:admin/utils/spacing.dart';
import 'package:flutter/material.dart';

class JudgeNotif extends StatelessWidget {
  const JudgeNotif({super.key, required this.title, required this.onRemove});

  final String title;
  final Function onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(defaultSpacing / 2),
      margin: const EdgeInsets.only(bottom: defaultSpacing),
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
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              onRemove();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
