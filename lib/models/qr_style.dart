/// Defines the visual styling options for QR codes.
///
/// This enum provides 10 distinct visual styles for QR codes, ranging from the
/// standard solid pattern to artistic styles with special effects. All styles
/// maintain the QR code's scannability while offering various aesthetic options.
///
/// These styles only apply to QR codes and have no effect on other barcode types
/// like EAN-13 or Code 128.
///
/// Example usage:
/// ```dart
/// // Create a QR code with a gradient style
/// QrBarGenView(
///   data: 'https://flutter.dev',
///   type: QrBarType.qr,
///   qrStyle: QrStyle.gradient,
///   fg: Colors.blue,
///   secondaryColor: Colors.purple,
/// );
/// ```
///
/// Most styles work with standard QR code readers, but some of the more decorative
/// styles might reduce scannability with low-quality cameras. The standard style
/// provides maximum compatibility.
enum QrStyle {
  /// Standard QR code with solid colors (default)
  ///
  /// This is the classic QR code appearance with square modules and solid colors.
  /// Provides maximum compatibility with all QR code scanners.
  ///
  /// Example parameters:
  /// - fg: Sets the color of all QR modules
  /// - bg: Sets the background color
  standard,

  /// Rounded corners on QR modules for a softer look
  ///
  /// Maintains the standard QR pattern but replaces square data modules with
  /// circles, creating a softer, more modern appearance.
  ///
  /// The eye patterns remain square for better recognition while the data
  /// modules are circular.
  rounded,

  /// QR code with a logo/image in the center
  ///
  /// Embeds a custom logo or image in the center of the QR code. QR codes have
  /// built-in error correction that allows parts of the code to be obscured
  /// while remaining functional.
  ///
  /// Requires the [logo] parameter to be set with an ImageProvider. The logo
  /// should not be too large (typically not more than 25% of the QR size).
  withLogo,

  /// QR code with gradient coloring
  ///
  /// Applies a smooth color transition from the primary color to the secondary
  /// color across the QR code, creating a visually appealing gradient effect.
  ///
  /// Requires the [secondaryColor] parameter to be set. The gradient runs
  /// from top-left to bottom-right.
  gradient,

  /// QR code with distinct eye styling
  ///
  /// Customizes the three positioning marker squares (eyes) in the corners of
  /// the QR code with a different color and circular shape.
  ///
  /// Uses the [secondaryColor] parameter to color the eye patterns, while the
  /// main data modules use the standard [fg] color.
  fancyEyes,

  /// QR code with dot-pattern modules
  ///
  /// Renders all modules (both eyes and data) as circles instead of squares,
  /// creating a distinctive dotted appearance.
  ///
  /// This style creates a more modern, softer visual while maintaining
  /// good scannability.
  dots,

  /// QR code with a custom frame around it
  ///
  /// Adds a decorative border around the QR code with customizable color
  /// and width.
  ///
  /// Uses the [frameColor] parameter for the border color and [frameWidth]
  /// for the border thickness. The border has rounded corners.
  framed,

  /// QR code with a shadow effect
  ///
  /// Applies a drop shadow behind the QR code for a subtle 3D effect.
  ///
  /// Customizable with [shadowColor], [shadowOffset], and [shadowBlurRadius]
  /// parameters to control the appearance of the shadow.
  shadow,

  /// QR code with alternating colors in a checkerboard pattern
  ///
  /// Creates a two-tone effect by alternating between two colors in a
  /// checkerboard pattern across the QR modules.
  ///
  /// Uses the [fg] color for the primary modules and [secondaryColor] for
  /// the alternating modules to create a distinctive mosaic pattern.
  mosaic,

  /// QR code that emulates a retro pixel art style
  ///
  /// Applies different colors to different parts of the QR code to create a
  /// retro gaming aesthetic, with different colors for the corners, edges,
  /// and central data.
  ///
  /// Uses all three color parameters:
  /// - [fg] for the main data modules
  /// - [secondaryColor] for the edges
  /// - [tertiaryColor] for the corner patterns
  pixelArt,
}

/// Extension providing user-friendly labels for [QrStyle] enum values.
///
/// This extension adds a [label] getter that returns a human-readable
/// description of each QR style, suitable for display in user interfaces
/// like dropdown menus or settings screens.
///
/// Example usage:
/// ```dart
/// // Display the style name in a UI element
/// Text('Selected style: ${QrStyle.gradient.label}');
///
/// // Use in a dropdown menu
/// DropdownButton<QrStyle>(
///   items: QrStyle.values.map((style) {
///     return DropdownMenuItem<QrStyle>(
///       value: style,
///       child: Text(style.label),
///     );
///   }).toList(),
///   onChanged: (style) {
///     // Handle style change
///   },
/// )
/// ```
extension QrStyleExt on QrStyle {
  /// Returns a human-readable label for each QR style.
  ///
  /// These labels are appropriate for displaying to users in the UI
  /// and use clear terminology to describe each visual style.
  String get label {
    switch (this) {
      case QrStyle.standard:
        return 'Standard';
      case QrStyle.rounded:
        return 'Rounded';
      case QrStyle.withLogo:
        return 'With Logo';
      case QrStyle.gradient:
        return 'Gradient';
      case QrStyle.fancyEyes:
        return 'Fancy Eyes';
      case QrStyle.dots:
        return 'Dots';
      case QrStyle.framed:
        return 'Framed';
      case QrStyle.shadow:
        return 'Shadow';
      case QrStyle.mosaic:
        return 'Mosaic';
      case QrStyle.pixelArt:
        return 'Pixel Art';
    }
  }
}
