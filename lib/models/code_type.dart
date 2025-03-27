/// Defines the supported barcode and QR code formats for generation and scanning.
///
/// This enum represents various 1D and 2D code formats that can be used
/// throughout the package for consistent type handling between scanning
/// and generation operations.
///
/// Example usage:
/// ```dart
/// // Create a QR code
/// QrBarGenView(data: 'https://flutter.dev', type: QrBarType.qr);
///
/// // Handle a scanned barcode
/// onScan: (result) {
///   if (result.type == QrBarType.ean13) {
///     // Handle product code
///   }
/// }
/// ```
enum QrBarType {
  /// QR Code (2D)
  ///
  /// A popular square-shaped 2D barcode that can store various types of data.
  /// Supports up to several kilobytes of data, including URLs, text, and more.
  /// Has strong error correction capabilities and is widely used in mobile applications.
  qr,

  /// Code 128 (1D)
  ///
  /// A high-density linear barcode that can encode all 128 ASCII characters.
  /// Commonly used for shipping and packaging labels, inventory management.
  /// Supports variable length data with good data integrity.
  c128,

  /// EAN-13 (1D) – European Article Number
  ///
  /// A 13-digit barcode used worldwide for marking retail products.
  /// First digits typically represent the country code of the manufacturer.
  /// Fixed length (13 digits) and commonly used for retail items.
  ean13,

  /// UPC-A (1D) – Universal Product Code
  ///
  /// A 12-digit barcode widely used for tracking retail products in the US and Canada.
  /// Fixed length (12 digits) with the first digit typically being the number system digit.
  /// Similar to EAN-13 but with one fewer digit.
  upc,

  /// PDF417 (2D stacked linear barcode)
  ///
  /// A stacked linear barcode format that can store up to 1.1 kilobytes of data.
  /// Often used for ID cards, shipping labels, and airline boarding passes.
  /// Has high data density and good error correction.
  pdf417,

  /// Aztec Code (2D)
  ///
  /// A square grid 2D barcode with a distinctive bullseye pattern in the center.
  /// Can encode up to 3000+ characters with robust error correction.
  /// Often used for travel documents and transportation tickets.
  aztec,

  /// Data Matrix (2D)
  ///
  /// A square or rectangular 2D barcode consisting of black and white cells.
  /// Can encode up to 2335 alphanumeric characters with excellent reliability.
  /// Often used for marking small items and in industrial applications.
  dm,
}

/// Extension providing user-friendly labels for [QrBarType] enum values.
///
/// This extension adds a [label] getter that returns a human-readable
/// description of each barcode type, suitable for display in user interfaces.
///
/// Example usage:
/// ```dart
/// final typeLabel = QrBarType.ean13.label; // Returns "EAN-13"
/// Text("Scanned barcode type: ${result.type.label}");
/// ```
extension QrBarTypeExt on QrBarType {
  /// Returns a human-readable label for each barcode type.
  ///
  /// These labels are appropriate for displaying to users in the UI
  /// and use the standard naming conventions for each barcode format.
  String get label {
    switch (this) {
      case QrBarType.qr:
        return 'QR Code';
      case QrBarType.c128:
        return 'Code 128';
      case QrBarType.ean13:
        return 'EAN-13';
      case QrBarType.upc:
        return 'UPC';
      case QrBarType.pdf417:
        return 'PDF417';
      case QrBarType.aztec:
        return 'Aztec';
      case QrBarType.dm:
        return 'Data Matrix';
    }
  }
}
