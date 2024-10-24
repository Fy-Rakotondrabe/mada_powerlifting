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
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  bool _isWifiConnected = false;
  bool _isCheckingServer = false;
  bool _showingDialog = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  static const String SERVER_KEY = 'last_server_address';

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    await checkWifiStatus();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> result) async {
        log(result.toString());
        if (result.contains(ConnectivityResult.wifi)) {
          if (_showingDialog) {
            Navigator.of(context).pop();
            _showingDialog = false;
          }
          await checkStoredServer();
        }
      },
    );
  }

  Future<void> checkStoredServer() async {
    if (!_isWifiConnected || _isCheckingServer) return;

    _isCheckingServer = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedServer = prefs.getString(SERVER_KEY);

      if (storedServer != null) {
        try {
          ref.read(serverProvider.notifier).init(storedServer);
          if (mounted && !_showingDialog) {
            _showingDialog = true;
            await showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              showDragHandle: false,
              builder: (BuildContext context) {
                return RoleDialog();
              },
            );
            _showingDialog = false;
          }
        } catch (e) {
          if (mounted) {
            await prefs.remove(SERVER_KEY);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Failed to connect to stored server. Please scan again.'),
              ),
            );
          }
        }
      }
    } finally {
      _isCheckingServer = false;
    }
  }

  Future<void> saveServerAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SERVER_KEY, address);
  }

  Future<void> checkWifiStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (mounted) {
      setState(() {
        _isWifiConnected = connectivityResult.contains(ConnectivityResult.wifi);
      });

      if (!_isWifiConnected && !_showingDialog) {
        _showingDialog = true;
        await showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          builder: (BuildContext context) {
            return WifiBottomSheet();
          },
        );
        _showingDialog = false;
      }
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
      onDetect: (BarcodeCapture capture) async {
        if (_showingDialog) return; // Prevent multiple dialogs

        final String? scannedValue = capture.barcodes.first.rawValue;

        if (scannedValue != null && scannedValue.contains('http')) {
          try {
            ref.read(serverProvider.notifier).init(scannedValue);
            await saveServerAddress(scannedValue);

            if (mounted && !_showingDialog) {
              _showingDialog = true;
              await showModalBottomSheet(
                context: context,
                isDismissible: false,
                enableDrag: false,
                showDragHandle: false,
                builder: (BuildContext context) {
                  return RoleDialog();
                },
              );
              _showingDialog = false;
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connection Error'),
                ),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid QR Code'),
              ),
            );
          }
        }
      },
      validator: (value) {
        return value.barcodes.isNotEmpty;
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
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
