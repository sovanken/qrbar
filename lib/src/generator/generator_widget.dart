import 'package:flutter/material.dart';
import '../../models/code_type.dart';
import '../../models/generate_options.dart';
import '../../models/qr_style.dart';
import 'generator.dart';

/// A ready-to-use Flutter widget for generating and displaying QR codes and barcodes.
///
/// This stateless widget provides a convenient way to display any supported barcode
/// or QR code directly in your widget tree. It handles all the complexity of rendering
/// different code types and styles through a simple, unified interface.
///
/// [QrBarGenView] is the primary widget that most applications will use for displaying
/// codes. It accepts all the same configuration options as the underlying [QrBarGenOpts]
/// class but as direct parameters, making it easier to use in widget declarations.
///
/// Features:
/// - Supports all barcode types defined in [QrBarType]
/// - Provides 10 different QR code styles through [QrStyle]
/// - Fully customizable appearance (colors, size, styling)
/// - Simple drop-in widget for Flutter layouts
///
/// Basic usage examples:
/// ```dart
/// // Simple QR code
/// QrBarGenView(
///   data: 'https://flutter.dev',
///   type: QrBarType.qr,
/// )
///
/// // Styled QR code with custom colors and gradient effect
/// QrBarGenView(
///   data: 'https://flutter.dev',
///   type: QrBarType.qr,
///   qrStyle: QrStyle.gradient,
///   fg: Colors.purple,
///   secondaryColor: Colors.blue,
///   size: 250,
/// )
///
/// // EAN-13 product barcode
/// QrBarGenView(
///   data: '5901234123457',
///   type: QrBarType.ean13,
///   size: 200,
///   fg: Colors.black,
///   bg: Colors.white,
/// )
/// ```
///
/// The widget can be placed in any widget tree location where a normal Flutter
/// widget would be accepted:
/// ```dart
/// Scaffold(
///   appBar: AppBar(title: Text('My QR Code')),
///   body: Center(
///     child: QrBarGenView(
///       data: 'https://flutter.dev',
///       type: QrBarType.qr,
///       qrStyle: QrStyle.framed,
///       frameColor: Colors.blue,
///     ),
///   ),
/// )
/// ```
class QrBarGenView extends StatelessWidget {
  /// The data to encode in the QR/barcode.
  ///
  /// This can be any text string for QR codes (URLs, contact info, plain text).
  /// For specific barcode types like EAN-13 or UPC-A, this must be valid numeric
  /// data with the correct number of digits.
  ///
  /// Examples:
  /// - For QR: 'https://example.com' or 'WIFI:S:MyNetwork;P:mypassword;;'
  /// - For EAN-13: '5901234123457' (must be 13 digits)
  /// - For UPC-A: '042100005264' (must be 12 digits)
  final String data;

  /// The type of code to generate.
  ///
  /// This determines the fundamental format and appearance of the generated code.
  /// See [QrBarType] for all supported formats and their specific requirements.
  ///
  /// Different barcode types have different data format requirements:
  /// - QR codes can encode any text, including URLs, contact information, etc.
  /// - EAN-13 requires exactly 13 numeric digits
  /// - UPC-A requires exactly 12 numeric digits
  /// - Code 128 can encode alphanumeric data
  final QrBarType type;

  /// The size (width and height) of the rendered code widget.
  ///
  /// For square codes (QR, Aztec, Data Matrix), this is both width and height.
  /// For linear barcodes (EAN-13, UPC-A, Code 128), the height is adjusted
  /// proportionally based on barcode type to maintain the correct aspect ratio.
  ///
  /// Defaults to `200.0` logical pixels.
  final double size;

  /// Background color of the code.
  ///
  /// This is the color of the empty/white space in the code.
  /// For maximum scannability, high contrast between background and
  /// foreground colors is recommended.
  ///
  /// Defaults to `Colors.white`.
  final Color bg;

  /// Foreground color of the code (the black bars/modules).
  ///
  /// This is the color of the data modules/bars in the code.
  /// For maximum scannability, high contrast between foreground and
  /// background colors is recommended.
  ///
  /// Defaults to `Colors.black`.
  final Color fg;

  /// Style option for QR codes (ignored for other barcode types).
  ///
  /// This parameter selects from 10 visual styles for QR codes, ranging from
  /// the standard pattern to artistic styles with special effects.
  ///
  /// See [QrStyle] for all available styles and their descriptions.
  ///
  /// Defaults to `QrStyle.standard`.
  ///
  /// Note: This parameter has no effect for non-QR barcode types.
  final QrStyle qrStyle;

  /// Optional logo image to place in the center of QR codes.
  ///
  /// Only used when style is `QrStyle.withLogo`. This allows embedding a small
  /// image (like a company logo) in the center of the QR code.
  ///
  /// QR codes have error correction capabilities that allow them to remain
  /// scannable even when partially obscured, but the logo should not be too large.
  ///
  /// Example:
  /// ```dart
  /// QrBarGenView(
  ///   data: 'https://flutter.dev',
  ///   type: QrBarType.qr,
  ///   qrStyle: QrStyle.withLogo,
  ///   logo: AssetImage('assets/logo.png'),
  /// )
  /// ```
  ///
  /// Note: This parameter has no effect for non-QR barcode types or when
  /// using a QR style other than `QrStyle.withLogo`.
  final ImageProvider? logo;

  /// Optional secondary color for multi-color QR styles.
  ///
  /// Used for gradient, fancyEyes, mosaic, and pixelArt styles.
  /// This color is used in different ways depending on the style:
  /// - As the end color in gradients
  /// - As the color for eye patterns in fancyEyes style
  /// - As the alternate color in mosaic patterns
  /// - As a secondary color in pixelArt style
  ///
  /// If not specified, a default blue color will be used when needed.
  ///
  /// Note: This parameter has no effect for non-QR barcode types or for
  /// QR styles that don't use multiple colors.
  final Color? secondaryColor;

  /// Optional tertiary color for styles that use multiple colors.
  ///
  /// Currently used primarily in the pixelArt style to create a more
  /// distinctive retro aesthetic with three different colors.
  ///
  /// If not specified, a default red color will be used when needed.
  ///
  /// Note: This parameter has no effect for most barcode types and QR styles.
  final Color? tertiaryColor;

  /// Optional frame color for the framed style.
  ///
  /// Only used when style is `QrStyle.framed`. This defines the color of
  /// the decorative border around the QR code.
  ///
  /// If not specified, a default blue color will be used.
  ///
  /// Note: This parameter has no effect for non-QR barcode types or for
  /// QR styles other than `QrStyle.framed`.
  final Color? frameColor;

  /// Optional frame width for the framed style.
  ///
  /// Defines the thickness of the border when using `QrStyle.framed`.
  ///
  /// Defaults to `10.0` logical pixels.
  ///
  /// Note: This parameter has no effect for non-QR barcode types or for
  /// QR styles other than `QrStyle.framed`.
  final double frameWidth;

  /// Optional shadow color for the shadow style.
  ///
  /// Only used when style is `QrStyle.shadow`. Defines the color of the
  /// drop shadow rendered behind the QR code.
  ///
  /// If not specified, a semi-transparent black color will be used.
  ///
  /// Note: This parameter has no effect for non-QR barcode types or for
  /// QR styles other than `QrStyle.shadow`.
  final Color? shadowColor;

  /// Optional shadow offset for the shadow style.
  ///
  /// Controls the position of the shadow relative to the QR code when
  /// using `QrStyle.shadow`. Positive values place the shadow down and to the right.
  ///
  /// Defaults to `Offset(2.0, 2.0)`.
  ///
  /// Note: This parameter has no effect for non-QR barcode types or for
  /// QR styles other than `QrStyle.shadow`.
  final Offset shadowOffset;

  /// Optional shadow blur radius for the shadow style.
  ///
  /// Controls how diffuse/blurry the shadow appears when using `QrStyle.shadow`.
  /// Larger values create a more spread-out shadow effect.
  ///
  /// Defaults to `3.0`.
  ///
  /// Note: This parameter has no effect for non-QR barcode types or for
  /// QR styles other than `QrStyle.shadow`.
  final double shadowBlurRadius;

  /// Creates a new [QrBarGenView] widget to render a QR code or barcode.
  ///
  /// The [data] and [type] parameters are required. All other parameters
  /// have sensible defaults and can be customized as needed for specific
  /// visual styles.
  ///
  /// Style-specific parameters (like [logo], [frameColor], etc.) only
  /// have an effect when using the relevant QR style.
  ///
  /// Example for a gradient-styled QR code:
  /// ```dart
  /// QrBarGenView(
  ///   data: 'https://flutter.dev',
  ///   type: QrBarType.qr,
  ///   qrStyle: QrStyle.gradient,
  ///   fg: Colors.purple,
  ///   secondaryColor: Colors.blue,
  /// )
  /// ```
  const QrBarGenView({
    super.key,
    required this.data,
    required this.type,
    this.size = 200,
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

  @override
  Widget build(BuildContext context) {
    return QrBarGen.gen(
      QrBarGenOpts(
        data: data,
        type: type,
        size: size,
        bg: bg,
        fg: fg,
        qrStyle: qrStyle,
        logo: logo,
        secondaryColor: secondaryColor,
        tertiaryColor: tertiaryColor,
        frameColor: frameColor,
        frameWidth: frameWidth,
        shadowColor: shadowColor,
        shadowOffset: shadowOffset,
        shadowBlurRadius: shadowBlurRadius,
      ),
    );
  }
}
