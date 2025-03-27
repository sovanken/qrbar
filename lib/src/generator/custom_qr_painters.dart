import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

import '../../models/qr_style.dart';

/// A flexible widget for rendering QR codes with 10 distinct visual styles.
///
/// This widget provides a unified interface for rendering QR codes with various
/// visual styles while maintaining compatibility with the underlying qr_flutter
/// package. It handles everything from basic styling to complex effects like
/// gradients, shadows, and custom coloring patterns.
///
/// For simpler styles, it uses the standard [QrImageView] with customized parameters.
/// For more advanced styles, it generates a base QR image and applies custom
/// painting effects using specialized [CustomPainter] implementations.
///
/// The widget dynamically chooses the appropriate rendering approach based on the
/// selected [style], making it easy to switch between different visual appearances
/// without changing the rest of your code.
///
/// Example usage:
/// ```dart
/// // Basic style
/// CustomQrImage(
///   data: 'https://flutter.dev',
///   style: QrStyle.standard,
/// )
///
/// // Gradient style with custom colors
/// CustomQrImage(
///   data: 'https://flutter.dev',
///   style: QrStyle.gradient,
///   foregroundColor: Colors.purple,
///   secondaryColor: Colors.blue,
/// )
///
/// // Framed style
/// CustomQrImage(
///   data: 'https://flutter.dev',
///   style: QrStyle.framed,
///   frameColor: Colors.green,
///   frameWidth: 15.0,
/// )
/// ```
///
/// This widget is typically not used directly by application code but is
/// instead accessed through [QrBarGenView] or [QrBarGen.gen()].
class CustomQrImage extends StatelessWidget {
  /// The data to encode in the QR code.
  final String data;

  /// The visual style to apply to the QR code.
  final QrStyle style;

  /// The size (width and height) of the QR code.
  final double size;

  /// The color for QR code modules (the "black" parts).
  final Color foregroundColor;

  /// The background color of the QR code (the "white" parts).
  final Color backgroundColor;

  /// Secondary color used for gradient, mosaic, fancyEyes, and pixelArt styles.
  final Color? secondaryColor;

  /// Tertiary color used for the pixelArt style.
  final Color? tertiaryColor;

  /// Frame color for the framed style.
  final Color? frameColor;

  /// Width of the frame when using the framed style.
  final double frameWidth;

  /// Offset of the shadow when using the shadow style.
  final Offset shadowOffset;

  /// Blur radius of the shadow when using the shadow style.
  final double shadowBlurRadius;

  /// Color of the shadow when using the shadow style.
  final Color? shadowColor;

  /// Optional image to embed in the center of the QR code.
  ///
  /// Most effective with the withLogo style, but can be used with standard style too.
  final ImageProvider? embeddedImage;

  /// Creates a new CustomQrImage with the specified style and properties.
  ///
  /// The [data] parameter is required and contains the text to encode.
  /// The [style] parameter selects which visual style to apply.
  ///
  /// Different properties affect different styles:
  /// - [foregroundColor] and [backgroundColor] affect all styles
  /// - [secondaryColor] is used for gradient, mosaic, fancyEyes, and pixelArt styles
  /// - [tertiaryColor] is only used for the pixelArt style
  /// - [frameColor] and [frameWidth] only affect the framed style
  /// - [shadowColor], [shadowOffset], and [shadowBlurRadius] only affect the shadow style
  /// - [embeddedImage] is primarily used with the withLogo style
  const CustomQrImage({
    Key? key,
    required this.data,
    this.style = QrStyle.standard,
    this.size = 200.0,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.secondaryColor,
    this.tertiaryColor,
    this.frameColor,
    this.frameWidth = 10.0,
    this.shadowOffset = const Offset(2.0, 2.0),
    this.shadowBlurRadius = 3.0,
    this.shadowColor,
    this.embeddedImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case QrStyle.standard:
        return QrImageView(
          data: data,
          size: size,
          backgroundColor: backgroundColor,
          eyeStyle: QrEyeStyle(
            eyeShape: QrEyeShape.square,
            color: foregroundColor,
          ),
          dataModuleStyle: QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.square,
            color: foregroundColor,
          ),
          embeddedImage: embeddedImage,
        );
      case QrStyle.rounded:
        return QrImageView(
          data: data,
          size: size,
          backgroundColor: backgroundColor,
          eyeStyle: QrEyeStyle(
            eyeShape: QrEyeShape.square,
            color: foregroundColor,
          ),
          dataModuleStyle: QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.circle,
            color: foregroundColor,
          ),
        );
      case QrStyle.dots:
        return QrImageView(
          data: data,
          size: size,
          backgroundColor: backgroundColor,
          eyeStyle: QrEyeStyle(
            eyeShape: QrEyeShape.circle,
            color: foregroundColor,
          ),
          dataModuleStyle: QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.circle,
            color: foregroundColor,
          ),
        );
      case QrStyle.withLogo:
        return QrImageView(
          data: data,
          size: size,
          backgroundColor: backgroundColor,
          eyeStyle: QrEyeStyle(color: foregroundColor),
          dataModuleStyle: QrDataModuleStyle(color: foregroundColor),
          embeddedImage: embeddedImage,
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: Size.square(size * 0.2),
          ),
        );
      case QrStyle.fancyEyes:
        return QrImageView(
          data: data,
          size: size,
          backgroundColor: backgroundColor,
          eyeStyle: QrEyeStyle(
            eyeShape: QrEyeShape.circle,
            color: secondaryColor ?? Colors.blue,
          ),
          dataModuleStyle: QrDataModuleStyle(color: foregroundColor),
        );
      case QrStyle.framed:
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: frameColor ?? Colors.blue,
              width: frameWidth,
            ),
            borderRadius: BorderRadius.circular(frameWidth),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(frameWidth / 2),
            child: QrImageView(
              data: data,
              size: size - (frameWidth * 2),
              backgroundColor: backgroundColor,
              eyeStyle: QrEyeStyle(color: foregroundColor),
              dataModuleStyle: QrDataModuleStyle(color: foregroundColor),
            ),
          ),
        );
      case QrStyle.gradient:
      case QrStyle.shadow:
      case QrStyle.mosaic:
      case QrStyle.pixelArt:
        // For these more complex styles, we'll use a shader-based approach
        return FutureBuilder<ui.Image>(
          future: _generateQrImage(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                width: size,
                height: size,
                color: backgroundColor,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return CustomPaint(
              size: Size(size, size),
              painter: _getCustomPainter(snapshot.data!),
            );
          },
        );
    }
  }

  /// Generates a base QR code image for use with advanced painting effects.
  ///
  /// This method creates a standard QR code using the QrPainter from the
  /// qr_flutter package, renders it to an offscreen canvas, and returns it
  /// as a ui.Image object that can be used as the basis for more complex
  /// visual effects.
  ///
  /// The generated image has transparent background and black modules,
  /// making it suitable for applying various color transformations.
  Future<ui.Image> _generateQrImage() async {
    final QrPainter painter = QrPainter(
      data: data,
      color: Colors.black,
      emptyColor: Colors.transparent,
      version: QrVersions.auto,
    );

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    painter.paint(canvas, Size(size, size));
    return recorder.endRecording().toImage(size.toInt(), size.toInt());
  }

  /// Returns the appropriate painter based on the selected style.
  ///
  /// This method selects and configures the correct [CustomPainter] for the
  /// current style, passing along all the necessary parameters like colors
  /// and the base QR image to use.
  ///
  /// It serves as a factory method for creating style-specific painters.
  CustomPainter _getCustomPainter(ui.Image qrImage) {
    switch (style) {
      case QrStyle.gradient:
        return GradientQrImagePainter(
          qrImage: qrImage,
          primaryColor: foregroundColor,
          secondaryColor: secondaryColor ?? Colors.blue,
          backgroundColor: backgroundColor,
        );
      case QrStyle.shadow:
        return ShadowQrImagePainter(
          qrImage: qrImage,
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          shadowColor: shadowColor ?? Colors.black.withOpacity(0.5),
          shadowOffset: shadowOffset,
          shadowBlurRadius: shadowBlurRadius,
        );
      case QrStyle.mosaic:
        return MosaicQrImagePainter(
          qrImage: qrImage,
          primaryColor: foregroundColor,
          secondaryColor: secondaryColor ?? Colors.blue,
          backgroundColor: backgroundColor,
        );
      case QrStyle.pixelArt:
        return PixelArtQrImagePainter(
          qrImage: qrImage,
          primaryColor: foregroundColor,
          secondaryColor: secondaryColor ?? Colors.green,
          tertiaryColor: tertiaryColor ?? Colors.red,
          backgroundColor: backgroundColor,
        );
      default:
        // Should never happen but provide a fallback
        return BasicQrImagePainter(
          qrImage: qrImage,
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
        );
    }
  }
}

/// A basic painter that renders a QR code image with a solid color.
///
/// This painter serves as the foundation for more complex QR code styles
/// and is also used as a fallback option. It simply draws the QR code
/// with the specified foreground color over the specified background color.
///
/// The class uses Flutter's [CustomPainter] system along with color filters
/// to apply the desired colors to the base QR image.
class BasicQrImagePainter extends CustomPainter {
  /// The base QR code image to render.
  final ui.Image qrImage;

  /// The color to use for the QR code modules.
  final Color foregroundColor;

  /// The background color of the QR code.
  final Color backgroundColor;

  /// Creates a new BasicQrImagePainter with the specified parameters.
  BasicQrImagePainter({
    required this.qrImage,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // QR code
    final paint = Paint()
      ..colorFilter = ColorFilter.mode(foregroundColor, BlendMode.srcIn);
    canvas.drawImage(qrImage, Offset.zero, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A painter that renders a QR code with a smooth gradient effect.
///
/// This painter creates a visually appealing QR code where the modules
/// transition smoothly from one color to another in a linear gradient.
/// The gradient runs from the top-left to the bottom-right corner.
///
/// This style adds visual interest to QR codes while maintaining readability
/// by most QR code scanners.
class GradientQrImagePainter extends CustomPainter {
  /// The base QR code image to render.
  final ui.Image qrImage;

  /// The starting color of the gradient.
  final Color primaryColor;

  /// The ending color of the gradient.
  final Color secondaryColor;

  /// The background color of the QR code.
  final Color backgroundColor;

  /// Creates a new GradientQrImagePainter with the specified parameters.
  GradientQrImagePainter({
    required this.qrImage,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Create gradient shader
    final gradientShader = ui.Gradient.linear(
      Offset.zero,
      Offset(size.width, size.height),
      [primaryColor, secondaryColor],
      null, // Use default stops
    );

    // Apply gradient to QR code
    final paint = Paint()
      ..shader = gradientShader
      ..blendMode = BlendMode.srcIn;
    canvas.drawImage(qrImage, Offset.zero, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A painter that renders a QR code with a shadow effect.
///
/// This painter creates a QR code with a subtle drop shadow, giving it
/// a raised, 3D appearance. The shadow is rendered beneath the QR code
/// with the specified offset, color, and blur radius.
///
/// The effect adds a modern design element while maintaining the QR
/// code's scannability.
class ShadowQrImagePainter extends CustomPainter {
  /// The base QR code image to render.
  final ui.Image qrImage;

  /// The color of the QR code modules.
  final Color foregroundColor;

  /// The background color of the QR code.
  final Color backgroundColor;

  /// The color of the shadow.
  final Color shadowColor;

  /// The offset of the shadow relative to the QR code.
  final Offset shadowOffset;

  /// The blur radius of the shadow, controlling how diffuse it appears.
  final double shadowBlurRadius;

  /// Creates a new ShadowQrImagePainter with the specified parameters.
  ShadowQrImagePainter({
    required this.qrImage,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.shadowColor,
    required this.shadowOffset,
    required this.shadowBlurRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Shadow
    final shadowPaint = Paint()
      ..colorFilter = ColorFilter.mode(shadowColor, BlendMode.srcIn)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlurRadius);
    canvas.drawImage(qrImage, shadowOffset, shadowPaint);

    // QR code
    final paint = Paint()
      ..colorFilter = ColorFilter.mode(foregroundColor, BlendMode.srcIn);
    canvas.drawImage(qrImage, Offset.zero, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A painter that renders a QR code with a checkerboard pattern effect.
///
/// This painter creates a QR code where the modules are colored in
/// an alternating pattern of two colors, creating a mosaic or
/// checkerboard visual effect. The pattern follows a grid where
/// adjacent cells have different colors.
///
/// This style adds visual interest while maintaining readability
/// by most QR code scanners.
class MosaicQrImagePainter extends CustomPainter {
  /// The base QR code image to render.
  final ui.Image qrImage;

  /// The primary color for the checkerboard pattern.
  final Color primaryColor;

  /// The secondary color for the checkerboard pattern.
  final Color secondaryColor;

  /// The background color of the QR code.
  final Color backgroundColor;

  /// Creates a new MosaicQrImagePainter with the specified parameters.
  MosaicQrImagePainter({
    required this.qrImage,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Create a checkerboard pattern
    final color1 = primaryColor;
    final color2 = secondaryColor;

    // Apply the first color
    final paint1 = Paint()
      ..colorFilter = ColorFilter.mode(color1, BlendMode.srcIn);
    canvas.drawImage(qrImage, Offset.zero, paint1);

    // Apply a more basic approach for the checkerboard effect
    // Instead of using a complex matrix transformation which causes type errors

    // First, we'll create a semi-transparent version with the second color
    final paint2 = Paint()
      ..colorFilter =
          ColorFilter.mode(color2.withOpacity(0.5), BlendMode.srcIn);

    // We'll divide the QR code into cells and color alternate cells
    final cellSize = size.width / 10; // Approximate size of each checker cell

    for (int x = 0; x < 10; x++) {
      for (int y = 0; y < 10; y++) {
        // Only color alternating cells
        if ((x + y) % 2 == 0) {
          final rect =
              Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize);

          // Draw this cell with the second color
          canvas.saveLayer(rect, paint2);
          canvas.drawImage(qrImage, Offset.zero, Paint());
          canvas.restore();
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A painter that renders a QR code with a pixel art aesthetic.
///
/// This painter creates a QR code with a retro gaming appearance by
/// applying different colors to different regions of the code. The
/// three finder patterns (large squares in the corners) are colored
/// distinctly from the rest of the data, creating a visually distinctive
/// style reminiscent of pixel art.
///
/// This style adds a playful, retro aesthetic while maintaining
/// compatibility with most QR code scanners.
class PixelArtQrImagePainter extends CustomPainter {
  /// The base QR code image to render.
  final ui.Image qrImage;

  /// The color for the main data modules.
  final Color primaryColor;

  /// The color for two of the finder patterns (corners).
  final Color secondaryColor;

  /// The color for one of the finder patterns (top-left corner).
  final Color tertiaryColor;

  /// The background color of the QR code.
  final Color backgroundColor;

  /// Creates a new PixelArtQrImagePainter with the specified parameters.
  PixelArtQrImagePainter({
    required this.qrImage,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // QR code - primary color for main content
    final paint1 = Paint()
      ..colorFilter = ColorFilter.mode(primaryColor, BlendMode.srcIn);
    canvas.drawImage(qrImage, Offset.zero, paint1);

    // Apply special colors to the corner patterns (approximation)
    // Since we can't easily determine the corner patterns, we'll use position
    // to apply different colors to different regions

    final cornerSize = size.width * 0.2; // Approximate position detector size

    // Top-left corner - tertiary color
    canvas.saveLayer(
      Rect.fromLTWH(0, 0, cornerSize, cornerSize),
      Paint()..colorFilter = ColorFilter.mode(tertiaryColor, BlendMode.srcIn),
    );
    canvas.drawImage(qrImage, Offset.zero, Paint());
    canvas.restore();

    // Top-right corner - secondary color
    canvas.saveLayer(
      Rect.fromLTWH(size.width - cornerSize, 0, cornerSize, cornerSize),
      Paint()..colorFilter = ColorFilter.mode(secondaryColor, BlendMode.srcIn),
    );
    canvas.drawImage(qrImage, Offset.zero, Paint());
    canvas.restore();

    // Bottom-left corner - secondary color
    canvas.saveLayer(
      Rect.fromLTWH(0, size.height - cornerSize, cornerSize, cornerSize),
      Paint()..colorFilter = ColorFilter.mode(secondaryColor, BlendMode.srcIn),
    );
    canvas.drawImage(qrImage, Offset.zero, Paint());
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
