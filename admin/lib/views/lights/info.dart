import 'dart:developer';

import 'package:admin/providers/meet.dart';
import 'package:admin/providers/server.dart';
import 'package:admin/utils/const.dart';
import 'package:admin/utils/encrypt_url.dart';
import 'package:admin/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MeetInfo extends ConsumerWidget {
  const MeetInfo({super.key});

  void _showQrDialog(BuildContext context, String serverUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Scan QR Code to Connect',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                QrImageView(
                  data: serverUrl,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverUrl = ref.watch(serverUrlProvider);
    final meetState = ref.watch(meetProvider);
    final encryptedUrl = encryptUrl(serverUrl, encryptionKey);

    return Container(
      padding: const EdgeInsets.all(defaultSpacing),
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            meetState.currentMeet?.name ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          spacing(double.infinity, defaultSpacing),
          TextButton(
            onPressed: () {
              _showQrDialog(context, encryptedUrl);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.cast_connected),
                SizedBox(
                  width: defaultSpacing,
                ),
                Text('Connect judge'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
