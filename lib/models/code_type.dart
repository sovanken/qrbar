/// The supported QR and barcode types for generation and scanning.
enum QrBarType {
  /// QR Code (2D)
  qr,

  /// Code 128 (1D)
  c128,

  /// EAN-13 (1D) – European Article Number
  ean13,

  /// UPC-A (1D) – Universal Product Code
  upc,

  /// PDF417 (2D stacked linear barcode)
  pdf417,

  /// Aztec Code (2D)
  aztec,

  /// Data Matrix (2D)
  dm,
}

/// Extension to get user-friendly labels for [QrBarType].
extension QrBarTypeExt on QrBarType {
  /// Returns a readable label for each barcode type.
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
