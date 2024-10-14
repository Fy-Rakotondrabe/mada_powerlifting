import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lights/model/judge.dart';
import 'package:lights/providers/meet.dart';
import 'package:lights/providers/server.dart';
import 'package:lights/router.dart';
import 'package:lights/utils/const.dart';

class RoleDialog extends ConsumerWidget {
  RoleDialog({super.key});

  final String id = uuid.v4();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void addJudge(Judge judge) {
      ref.read(meetProvider.notifier).setJudge(judge);
      ref.read(serverProvider).connection?.addJudge(judge).then((_) {
        ref.read(serverProvider).connection?.getCurrentMeet().then((meet) {
          ref.read(meetProvider.notifier).setCurrentMeet(meet);
        }).catchError((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Failed to get meet / No current meet'),
            ),
          );
          GoRouter.of(context).replace(scanRoute);
        });
      });
    }

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
                onSelect: () {
                  addJudge(Judge(role: headJudge, id: id));
                },
              ),
              RoleButton(
                title: 'Side Judge 1',
                onSelect: () {
                  addJudge(Judge(role: sideJudge1, id: id));
                },
              ),
              RoleButton(
                title: 'Side Judge 2',
                onSelect: () {
                  addJudge(Judge(role: sideJudge2, id: id));
                },
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
