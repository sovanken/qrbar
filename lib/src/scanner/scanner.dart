import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../models/scan_result.dart';
import '../utils/barcode_type_mapper.dart';

/// Signature for the callback function triggered after a successful scan.
typedef QrBarOnScan = void Function(QrBarScanResult result);

/// A widget that opens the camera to scan QR codes and barcodes.
///
/// Internally uses the `mobile_scanner` package. Users receive scan results
/// via the [onScan] callback using the [QrBarScanResult] model.
///
/// This widget is intended to be placed on a full screen or a dedicated route.
class QrBarScanView extends StatefulWidget {
  /// Called when a QR or barcode is successfully scanned.
  final QrBarOnScan onScan;

  /// Whether to allow scanning the same code multiple times in a session.
  ///
  /// If `false`, the same value won't be re-scanned until reset.
  final bool allowMulti;

  /// Creates a new scanner widget that opens the camera to detect codes.
  const QrBarScanView({
    super.key,
    required this.onScan,
    this.allowMulti = false,
  });

  @override
  State<QrBarScanView> createState() => _QrBarScanViewState();
}

class _QrBarScanViewState extends State<QrBarScanView> {
  final MobileScannerController _ctrl = MobileScannerController();
  String? _lastScanned;

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: _ctrl,
      onDetect: (capture) {
        final code = capture.barcodes.firstOrNull;
        if (code == null || code.rawValue == null) return;

        final value = code.rawValue!;
        if (_lastScanned == value && !widget.allowMulti) return;
        _lastScanned = value;

        final type = mapFormatToQrBarType(code.format);
        widget.onScan(QrBarScanResult(value: value, type: type));
      },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}
