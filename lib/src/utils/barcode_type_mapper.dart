import 'package:mobile_scanner/mobile_scanner.dart';
import '../../models/code_type.dart';

/// Maps [BarcodeFormat] from the `mobile_scanner` package
/// to your own [QrBarType] enum.
///
/// This function acts as a bridge between external barcode formats
/// and the internal unified model used across the `qrbar` package.
///
/// Used internally by the scanner logic.
///
/// Example:
/// ```dart
/// final format = barcode.format;
/// final type = mapFormatToQrBarType(format);
/// ```
QrBarType mapFormatToQrBarType(BarcodeFormat format) {
  switch (format) {
    case BarcodeFormat.qrCode:
      return QrBarType.qr;
    case BarcodeFormat.code128:
      return QrBarType.c128;
    case BarcodeFormat.ean13:
      return QrBarType.ean13;
    case BarcodeFormat.upcA:
      return QrBarType.upc;
    case BarcodeFormat.pdf417:
      return QrBarType.pdf417;
    case BarcodeFormat.aztec:
      return QrBarType.aztec;
    case BarcodeFormat.dataMatrix:
      return QrBarType.dm;
    default:
      return QrBarType.qr;
  }
}
