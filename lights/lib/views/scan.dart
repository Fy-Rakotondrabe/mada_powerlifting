import 'dart:async';
import 'dart:developer';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lights/providers/server.dart';
import 'package:lights/utils/const.dart';
import 'package:lights/views/role.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  bool _isWifiConnected = false;

  @override
  void initState() {
    super.initState();
    checkWifiStatus();
    Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> result) {
        log(result.toString());
        if (result.contains(ConnectivityResult.wifi)) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Future<void> checkWifiStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isWifiConnected = connectivityResult == ConnectivityResult.wifi;
    });

    if (!_isWifiConnected) {
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (BuildContext context) {
          return WifiBottomSheet();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AiBarcodeScanner(
      onDispose: () {
        debugPrint("Barcode scanner disposed!");
      },
      hideGalleryButton: false,
      hideSheetDragHandler: true,
      hideSheetTitle: true,
      controller: MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
      ),
      onDetect: (BarcodeCapture capture) {
        /// The row string scanned barcode value
        final String? scannedValue = capture.barcodes.first.rawValue;

        if (scannedValue != null && scannedValue.contains('http')) {
          ref.read(serverProvider.notifier).init(scannedValue);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Connection Error'),
            ),
          );
        }

        showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          showDragHandle: false,
          builder: (BuildContext context) {
            return RoleDialog();
          },
        );
      },
      validator: (value) {
        if (value.barcodes.isEmpty) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  dispose() {
    super.dispose();
  }
}

class WifiBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultSpacing),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Please connect to Wi-Fi to continue',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => AppSettings.openAppSettings(
              type: AppSettingsType.wifi,
            ),
            child: const Text('Open Wi-Fi Settings'),
          ),
        ],
      ),
    );
  }
}
