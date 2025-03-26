import 'package:flutter/material.dart';
import '../../models/code_type.dart';
import '../../models/generate_options.dart';
import 'generator.dart';

/// A Flutter widget for generating and displaying QR codes or barcodes.
///
/// This is a high-level UI wrapper around the [QrBarGen] logic,
/// which simplifies rendering codes directly in your widget tree.
class QrBarGenView extends StatelessWidget {
  /// The data to encode in the QR/barcode (e.g., a URL, text, or number).
  final String data;

  /// The type of code to generate (QR, Code128, EAN13, etc.).
  final QrBarType type;

  /// The size (width and height) of the rendered code widget.
  ///
  /// Defaults to `200.0`.
  final double size;

  /// Background color of the code.
  ///
  /// Defaults to `Colors.white`.
  final Color bg;

  /// Foreground color of the code.
  ///
  /// Defaults to `Colors.black`.
  final Color fg;

  /// Creates a new [QrBarGenView] widget to render a QR or barcode.
  const QrBarGenView({
    super.key,
    required this.data,
    required this.type,
    this.size = 200,
    this.bg = Colors.white,
    this.fg = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return QrBarGen.gen(
      QrBarGenOpts(data: data, type: type, size: size, bg: bg, fg: fg),
    );
  }
}
