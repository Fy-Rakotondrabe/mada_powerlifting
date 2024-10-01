import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lights/router.dart';
import 'package:lights/utils/const.dart';

class RoleDialog extends StatelessWidget {
  const RoleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      showDragHandle: false,
      enableDrag: false,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: 260,
          padding: const EdgeInsets.all(defaultSpacing),
          child: Column(
            children: [
              const Text(
                'Choose your role',
                style: TextStyle(fontSize: 20),
              ),
              const Spacer(),
              RoleButton(
                title: 'Head Judge',
                onSelect: () {},
              ),
              RoleButton(
                title: 'Side Judge 1',
                onSelect: () {},
              ),
              RoleButton(
                title: 'Side Judge 2',
                onSelect: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}

class RoleButton extends StatelessWidget {
  const RoleButton({
    super.key,
    required this.onSelect,
    required this.title,
  });

  final String title;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelect();
        GoRouter.of(context).replace(lightsRoute);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: defaultSpacing),
        padding: const EdgeInsets.all(defaultSpacing / 2),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
