import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:lights/views/role.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

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
        debugPrint("Barcode scanned: $scannedValue");

        showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          showDragHandle: false,
          builder: (BuildContext context) {
            return const RoleDialog();
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
}
