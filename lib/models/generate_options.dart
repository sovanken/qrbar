import 'package:flutter/material.dart';
import 'code_type.dart';
import 'qr_style.dart';

/// Configuration options for generating QR codes and barcodes with customizable styling.
///
/// This class encapsulates all parameters needed to generate and style various types of
/// barcodes and QR codes. It provides a unified configuration interface that works across
/// all supported code formats, with special styling options for QR codes.
///
/// The configuration options include:
/// - Basic properties like data content, code type, and size
/// - Color customization for foreground and background
/// - Advanced styling for QR codes through the [qrStyle] property
/// - Style-specific parameters for effects like gradients, frames, and shadows
///
/// Example usage:
/// ```dart
/// // Basic QR code
/// final options = QrBarGenOpts(
///   data: 'https://flutter.dev',
///   type: QrBarType.qr,
/// );
///
/// // Gradient-styled QR code with custom colors
/// final gradientOptions = QrBarGenOpts(
///   data: 'https://flutter.dev',
///   type: QrBarType.qr,
///   qrStyle: QrStyle.gradient,
///   fg: Colors.purple,
///   secondaryColor: Colors.blue,
/// );
///
/// // EAN-13 barcode for a product
/// final barcodeOptions = QrBarGenOpts(
///   data: '5901234123457',
///   type: QrBarType.ean13,
///   size: 250.0,
/// );
/// ```
///
/// Note that QR-specific styling parameters (like [qrStyle], [logo], etc.) have no effect
/// when used with linear barcode types like EAN-13 or Code 128.
class QrBarGenOpts {
  /// The data (text, URL, number, etc.) to encode into the code.
  ///
  /// For QR codes, this can be any text content including URLs, contact information,
  /// or plain text. For barcode types like EAN-13 or UPC-A, this must be numeric
  /// data with the correct number of digits.
  final String data;

  /// The type of code to generate (QR, Code128, EAN13, etc.).
  ///
  /// This determines the fundamental format and appearance of the generated code.
  /// See [QrBarType] for all supported formats.
  final QrBarType type;

  /// The overall size (width/height) of the generated widget.
  ///
  /// For square codes (QR, Data Matrix, Aztec), this is both width and height.
  /// For linear barcodes, the height is adjusted proportionally to maintain
  /// the correct aspect ratio.
  ///
  /// Default is `200.0` logical pixels.
  final double size;

  /// Background color of the generated code.
  ///
  /// This is the color of the empty/white space in the code.
  /// For maximum scanability, high contrast between background and
  /// foreground colors is recommended.
  ///
  /// Default is `Colors.white`.
  final Color bg;

  /// Foreground color of the code (the code lines/pixels).
  ///
  /// This is the color of the data modules/bars in the code.
  /// For maximum scanability, high contrast between foreground and
  /// background colors is recommended.
  ///
  /// Default is `Colors.black`.
  final Color fg;

  /// Style option for QR codes (ignored for other barcode types).
  ///
  /// This allows selection from 10 different visual styles for QR codes,
  /// ranging from standard solid patterns to artistic styles with gradients,
  /// frames, or special effects.
  ///
  /// Default is `QrStyle.standard`.
  final QrStyle qrStyle;

  /// Optional logo image to place in the center of QR codes.
  ///
  /// Only used when style is `QrStyle.withLogo`. This allows embedding a small
  /// image (like a company logo) in the center of the QR code.
  ///
  /// QR codes have error correction capabilities that allow them to remain
  /// scannable even when partially obscured, but the logo should not be too large.
  final ImageProvider? logo;

  /// Optional secondary color for multi-color QR styles.
  ///
  /// Used for gradient, fancyEyes, mosaic, and pixelArt styles.
  /// This color is used in different ways depending on the style:
  /// - As the end color in gradients
  /// - As the color for eye patterns in fancyEyes style
  /// - As the alternate color in mosaic patterns
  /// - As a secondary color in pixelArt style
  final Color? secondaryColor;

  /// Optional tertiary color for styles that use multiple colors.
  ///
  /// Currently used primarily in the pixelArt style to create a more
  /// distinctive retro aesthetic with three different colors.
  final Color? tertiaryColor;

  /// Optional frame color for the framed style.
  ///
  /// Only used when style is `QrStyle.framed`. This defines the color of
  /// the decorative border around the QR code.
  final Color? frameColor;

  /// Optional frame width for the framed style.
  ///
  /// Defines the thickness of the border when using `QrStyle.framed`.
  /// Only used when style is `QrStyle.framed`.
  ///
  /// Default is `10.0` logical pixels.
  final double frameWidth;

  /// Optional shadow color for the shadow style.
  ///
  /// Only used when style is `QrStyle.shadow`. Defines the color of the
  /// drop shadow rendered behind the QR code.
  final Color? shadowColor;

  /// Optional shadow offset for the shadow style.
  ///
  /// Controls the position of the shadow relative to the QR code when
  /// using `QrStyle.shadow`. Positive values place the shadow down and to the right.
  ///
  /// Default is `Offset(2.0, 2.0)`. Only used when style is `QrStyle.shadow`.
  final Offset shadowOffset;

  /// Optional shadow blur radius for the shadow style.
  ///
  /// Controls how diffuse/blurry the shadow appears when using `QrStyle.shadow`.
  /// Larger values create a more spread-out shadow effect.
  ///
  /// Default is `3.0`. Only used when style is `QrStyle.shadow`.
  final double shadowBlurRadius;

  /// Creates a new set of generation options for use with QR/barcode widgets.
  ///
  /// The [data] and [type] parameters are required. All other parameters
  /// have sensible defaults and can be customized as needed for specific
  /// visual styles.
  const QrBarGenOpts({
    required this.data,
    required this.type,
    this.size = 200.0,
    this.bg = Colors.white,
    this.fg = Colors.black,
    this.qrStyle = QrStyle.standard,
    this.logo,
    this.secondaryColor,
    this.tertiaryColor,
    this.frameColor,
    this.frameWidth = 10.0,
    this.shadowColor,
    this.shadowOffset = const Offset(2.0, 2.0),
    this.shadowBlurRadius = 3.0,
  });
}
