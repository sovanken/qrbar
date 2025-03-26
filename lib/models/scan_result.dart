import 'code_type.dart';

/// The result from scanning a QR code or barcode.
///
/// Contains the scanned value, type, and timestamp.
class QrBarScanResult {
  /// The raw string value extracted from the scanned code.
  final String value;

  /// The format/type of the scanned code (e.g., QR, Code128, etc.).
  final QrBarType type;

  /// The time the code was scanned.
  ///
  /// Automatically set to `DateTime.now()` if not provided.
  final DateTime time;

  /// Creates a new scan result containing the scanned value and type.
  QrBarScanResult({required this.value, required this.type, DateTime? time})
      : time = time ?? DateTime.now();

  @override
  String toString() =>
      'QrBarScanResult(type: ${type.label}, value: $value, time: $time)';
}
