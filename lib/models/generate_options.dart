import 'package:flutter/material.dart';
import 'code_type.dart';

/// Configuration options for generating a QR code or barcode.
///
/// Used by the generator to control appearance and format.
class QrBarGenOpts {
  /// The data (text, URL, number, etc.) to encode into the code.
  final String data;

  /// The type of code to generate (QR, Code128, EAN13, etc.).
  final QrBarType type;

  /// The overall size (width/height) of the generated widget.
  ///
  /// Default is `200.0`.
  final double size;

  /// Background color of the generated code.
  ///
  /// Default is `Colors.white`.
  final Color bg;

  /// Foreground color of the code (the code lines/pixels).
  ///
  /// Default is `Colors.black`.
  final Color fg;

  /// Creates a new set of generation options for use with QR/barcode widgets.
  const QrBarGenOpts({
    required this.data,
    required this.type,
    this.size = 200.0,
    this.bg = Colors.white,
    this.fg = Colors.black,
  });
}
