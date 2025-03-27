import 'code_type.dart';

/// A model class that represents the result of a successful barcode or QR code scan.
///
/// This class encapsulates all information from a scanned code, including the raw
/// data value, the detected format type, and the timestamp when the scan occurred.
/// It provides a standardized structure for handling scan results throughout the
/// application.
///
/// Typically obtained from the [onScan] callback of [QrBarScanView]:
/// ```dart
/// QrBarScanView(
///   onScan: (QrBarScanResult result) {
///     // Process the scan result
///     print('Scanned a ${result.type.label}: ${result.value}');
///
///     // Check the scan type and handle accordingly
///     if (result.type == QrBarType.qr) {
///       // Handle QR code data
///       handleQrCodeData(result.value);
///     } else if (result.type == QrBarType.ean13) {
///       // Handle product barcode
///       lookupProduct(result.value);
///     }
///   },
/// )
/// ```
///
/// The class also provides a useful [toString] implementation for debugging
/// and logging purposes.
class QrBarScanResult {
  /// The raw string value extracted from the scanned code.
  ///
  /// This contains the decoded text content of the barcode or QR code.
  /// The format of this value depends on the code type:
  /// - For QR codes: can be any text, URL, contact info, etc.
  /// - For EAN/UPC: typically numeric digits
  /// - For Code 128: alphanumeric data
  ///
  /// This is the primary data payload that most applications will use
  /// for further processing.
  final String value;

  /// The format/type of the scanned code (e.g., QR, Code128, etc.).
  ///
  /// This indicates which barcode format was detected during scanning.
  /// The type is represented as a [QrBarType] enum value, which allows
  /// for easy handling of different code formats in application logic.
  ///
  /// Use this to determine how to interpret or process the [value].
  final QrBarType type;

  /// The timestamp when the code was scanned.
  ///
  /// This is automatically set to the current time ([DateTime.now()])
  /// if not explicitly provided to the constructor.
  ///
  /// Useful for:
  /// - Logging scan history
  /// - Implementing time-based validation
  /// - Tracking how recent a scan is
  final DateTime time;

  /// Creates a new scan result containing the scanned value and type.
  ///
  /// The [value] and [type] parameters are required and represent the
  /// essential data from the scan. The [time] parameter is optional
  /// and defaults to the current time when the object is created.
  ///
  /// Example:
  /// ```dart
  /// // Create a scan result for a URL QR code
  /// final result = QrBarScanResult(
  ///   value: 'https://flutter.dev',
  ///   type: QrBarType.qr,
  /// );
  ///
  /// // Create a scan result for a product barcode with custom timestamp
  /// final historicalScan = QrBarScanResult(
  ///   value: '5901234123457',
  ///   type: QrBarType.ean13,
  ///   time: DateTime(2023, 5, 15, 14, 30),
  /// );
  /// ```
  QrBarScanResult({required this.value, required this.type, DateTime? time})
      : time = time ?? DateTime.now();

  /// Returns a string representation of the scan result.
  ///
  /// The format is: 'QrBarScanResult(type: TYPE_LABEL, value: VALUE, time: TIME)'
  ///
  /// This is useful for debugging, logging, and displaying scan results
  /// in a readable format. The type is displayed using its human-readable
  /// label from the [QrBarType] extension.
  ///
  /// Example output:
  /// 'QrBarScanResult(type: QR Code, value: https://flutter.dev, time: 2023-05-15 14:30:00.000)'
  @override
  String toString() =>
      'QrBarScanResult(type: ${type.label}, value: $value, time: $time)';
}
