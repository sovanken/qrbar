import 'package:flutter/widgets.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../models/code_type.dart';
import '../../models/generate_options.dart';
import 'custom_qr_painters.dart';

/// Core generator utility that creates barcode and QR code widgets from configuration options.
///
/// This class serves as the central rendering engine of the library, translating
/// configuration options into properly rendered barcode widgets. It handles all supported
/// barcode types and provides specialized rendering for the 10 different QR code styles.
///
/// [QrBarGen] doesn't need to be instantiated - it provides a static [gen] method
/// that can be used directly to generate widgets. This approach makes the API simpler
/// and more functional.
///
/// Key functionality:
/// - Renders all supported 1D and 2D barcode formats
/// - Handles specialized rendering for the different QR code styles
/// - Automatically applies the correct dimensions for different barcode types
/// - Provides a consistent interface for all code generation needs
///
/// The internal implementation uses the appropriate widgets from the underlying
/// barcode libraries while abstracting away their implementation details.
class QrBarGen {
  /// Generates a Flutter widget for the specified barcode or QR code type.
  ///
  /// This method is the primary entry point for code generation. It takes a
  /// [QrBarGenOpts] object that fully describes the desired code and returns
  /// a ready-to-use Flutter widget.
  ///
  /// The method handles:
  /// - Selection of the appropriate rendering strategy based on code type
  /// - Application of styling parameters (colors, size, etc.)
  /// - Special handling for QR code styles
  ///
  /// For QR codes, the style is determined by the [QrBarGenOpts.qrStyle] property.
  /// For non-QR barcodes (EAN-13, Code 128, etc.), only basic styling options like
  /// size and colors are applied.
  ///
  /// Example usage:
  /// ```dart
  /// // Generate a standard QR code
  /// Widget qrCode = QrBarGen.gen(
  ///   QrBarGenOpts(
  ///     data: 'https://flutter.dev',
  ///     type: QrBarType.qr,
  ///   ),
  /// );
  ///
  /// // Generate a gradient-styled QR code
  /// Widget gradientQr = QrBarGen.gen(
  ///   QrBarGenOpts(
  ///     data: 'https://flutter.dev',
  ///     type: QrBarType.qr,
  ///     qrStyle: QrStyle.gradient,
  ///     fg: Colors.blue,
  ///     secondaryColor: Colors.purple,
  ///   ),
  /// );
  ///
  /// // Generate an EAN-13 barcode
  /// Widget barcode = QrBarGen.gen(
  ///   QrBarGenOpts(
  ///     data: '5901234123457',
  ///     type: QrBarType.ean13,
  ///     size: 250,
  ///   ),
  /// );
  ///
  /// // Use in a widget tree
  /// return Container(
  ///   padding: const EdgeInsets.all(16),
  ///   child: qrCode,
  /// );
  /// ```
  ///
  /// Returns a Widget that can be directly used in a Flutter widget tree.
  static Widget gen(QrBarGenOpts opts) {
    switch (opts.type) {
      case QrBarType.qr:
        // Handle different QR styles
        return _generateQrCode(opts);

      case QrBarType.c128:
        return BarcodeWidget(
          data: opts.data,
          barcode: Barcode.code128(),
          width: opts.size,
          height: opts.size / 3,
          backgroundColor: opts.bg,
          color: opts.fg,
        );

      case QrBarType.ean13:
        return BarcodeWidget(
          data: opts.data,
          barcode: Barcode.ean13(),
          width: opts.size,
          height: opts.size / 3,
          backgroundColor: opts.bg,
          color: opts.fg,
        );

      case QrBarType.upc:
        return BarcodeWidget(
          data: opts.data,
          barcode: Barcode.upcA(),
          width: opts.size,
          height: opts.size / 3,
          backgroundColor: opts.bg,
          color: opts.fg,
        );

      case QrBarType.pdf417:
        return BarcodeWidget(
          data: opts.data,
          barcode: Barcode.pdf417(),
          width: opts.size,
          height: opts.size / 2.5,
          backgroundColor: opts.bg,
          color: opts.fg,
        );

      case QrBarType.aztec:
        return BarcodeWidget(
          data: opts.data,
          barcode: Barcode.aztec(),
          width: opts.size,
          height: opts.size,
          backgroundColor: opts.bg,
          color: opts.fg,
        );

      case QrBarType.dm:
        return BarcodeWidget(
          data: opts.data,
          barcode: Barcode.dataMatrix(),
          width: opts.size,
          height: opts.size,
          backgroundColor: opts.bg,
          color: opts.fg,
        );
    }
  }

  /// Helper method to generate QR codes with various styling options.
  ///
  /// This private method handles the specialized rendering for QR codes,
  /// delegating to the [CustomQrImage] widget which implements the 10
  /// different QR code styles.
  ///
  /// The method maps parameters from [QrBarGenOpts] to the appropriate
  /// parameters of [CustomQrImage].
  ///
  /// This separation of concerns keeps the main [gen] method clean while
  /// allowing for sophisticated QR code styling.
  static Widget _generateQrCode(QrBarGenOpts opts) {
    // Use the unified CustomQrImage widget that supports all styles
    return CustomQrImage(
      data: opts.data,
      style: opts.qrStyle,
      size: opts.size,
      foregroundColor: opts.fg,
      backgroundColor: opts.bg,
      secondaryColor: opts.secondaryColor,
      tertiaryColor: opts.tertiaryColor,
      frameColor: opts.frameColor,
      frameWidth: opts.frameWidth,
      shadowOffset: opts.shadowOffset,
      shadowBlurRadius: opts.shadowBlurRadius,
      shadowColor: opts.shadowColor,
      embeddedImage: opts.logo,
    );
  }
}
