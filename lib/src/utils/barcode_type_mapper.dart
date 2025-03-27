import 'package:mobile_scanner/mobile_scanner.dart';
import '../../models/code_type.dart';

/// Converts external barcode format types to the package's internal type system.
///
/// This utility function maps the [BarcodeFormat] enum values from the
/// `mobile_scanner` package to the library's own [QrBarType] enum values.
/// It serves as an adapter layer that insulates the rest of the package
/// from dependencies on external format specifications.
///
/// Benefits of this approach:
/// - Creates a consistent type system across both scanning and generation
/// - Shields application code from changes in the underlying scanner library
/// - Allows for graceful fallback behavior for unsupported formats
/// - Simplifies the public API by presenting only one set of barcode types
///
/// The function handles all supported barcode formats and provides a default
/// mapping (to QR code) for any unrecognized formats, ensuring the API never
/// returns an invalid type.
///
/// This function is primarily used internally by the scanner implementation
/// and typically doesn't need to be called directly by application code.
///
/// Example usage within the scanner implementation:
/// ```dart
/// void onDetect(BarcodeCapture capture) {
///   final code = capture.barcodes.first;
///   final format = code.format;
///
///   // Convert external format to internal format
///   final type = mapFormatToQrBarType(format);
///
///   // Create a scan result with the internal type
///   final result = QrBarScanResult(
///     value: code.rawValue ?? '',
///     type: type,
///   );
///
///   // Notify listeners of the scan with consistent type information
///   onScan(result);
/// }
/// ```
///
/// If new barcode formats are added to the scanning library, this function
/// should be updated to map those formats to appropriate [QrBarType] values.
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
      // Fallback to QR code for any unrecognized formats
      return QrBarType.qr;
  }
}
