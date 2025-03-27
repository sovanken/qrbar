import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/code_type.dart';
import '../../models/generate_options.dart';
import '../../models/qr_style.dart';
import '../generator/generator.dart';
import 'render_utils.dart';

/// A powerful utility for exporting QR codes and barcodes as image files or raw bytes.
///
/// This class provides a set of static methods that make it easy to:
/// - Save barcodes as PNG files to the device's storage
/// - Share barcodes with other apps via the system share sheet
/// - Convert barcodes to raw bytes for custom handling
///
/// The exporter simplifies common workflows by handling all the complexity of
/// rendering codes to images and managing file operations, with a simple and
/// consistent API across all supported barcode types and QR code styles.
///
/// Key features:
/// - Generates high-quality PNG images with configurable resolution
/// - Works with all barcode types supported by the library
/// - Supports all 10 QR code styles including gradients, frames, etc.
/// - Provides platform-appropriate file paths on different operating systems
/// - Handles error conditions gracefully with informative debug logs
///
/// Usage examples:
/// ```dart
/// // Save a QR code to a file
/// final filePath = await QrExporter.saveToFile(
///   data: 'https://flutter.dev',
///   type: QrBarType.qr,
///   qrStyle: QrStyle.gradient,
///   filename: 'flutter_website',
/// );
/// if (filePath != null) {
///   print('Saved QR code to: $filePath');
/// }
///
/// // Share a QR code with other apps
/// await QrExporter.share(
///   data: 'WIFI:S:MyNetwork;P:password123;;',
///   type: QrBarType.qr,
///   subject: 'WiFi Connection',
/// );
///
/// // Get raw bytes for custom handling
/// final bytes = await QrExporter.getBytes(
///   data: '5901234123457',
///   type: QrBarType.ean13,
/// );
/// if (bytes != null) {
///   // Upload to server, embed in a document, etc.
/// }
/// ```
///
/// This utility is particularly useful for apps that need to:
/// - Let users save or share barcodes they've generated
/// - Store barcodes for later use in a database or file system
/// - Integrate barcodes with other systems via custom network requests
class QrExporter {
  /// Generates and saves a QR code or barcode as a PNG file on the device.
  ///
  /// This method handles the entire process of:
  /// 1. Generating the code with the specified options
  /// 2. Rendering it to a high-quality PNG image
  /// 3. Creating the appropriate directory if needed
  /// 4. Saving the file with the provided or auto-generated filename
  ///
  /// Returns the complete file path of the saved PNG file if successful,
  /// or null if an error occurred during the process.
  ///
  /// Parameters:
  /// - [data]: The content to encode in the barcode (required)
  /// - [type]: The type of barcode to generate (required)
  /// - [qrStyle]: The visual style for QR codes (ignored for other barcode types)
  /// - [fg], [bg]: Foreground and background colors
  /// - [secondaryColor], [tertiaryColor]: Additional colors for styled QR codes
  /// - [logo]: Optional logo for QR codes with the withLogo style
  /// - [size]: Size of the generated image in logical pixels
  /// - [filename]: Custom filename (without extension); auto-generated if not provided
  /// - [directory]: Custom directory path; uses platform-appropriate default if not provided
  ///
  /// Platform-specific behavior:
  /// - On Android/iOS: Uses the app's documents directory by default
  /// - On desktop: Uses the downloads directory if available, otherwise the documents directory
  ///
  /// Example:
  /// ```dart
  /// final filePath = await QrExporter.saveToFile(
  ///   data: 'https://example.com',
  ///   type: QrBarType.qr,
  ///   qrStyle: QrStyle.gradient,
  ///   fg: Colors.purple,
  ///   secondaryColor: Colors.blue,
  ///   filename: 'my-website-qr',
  /// );
  ///
  /// if (filePath != null) {
  ///   showSnackBar('QR code saved to: $filePath');
  /// } else {
  ///   showSnackBar('Failed to save QR code');
  /// }
  /// ```
  static Future<String?> saveToFile({
    required String data,
    required QrBarType type,
    QrStyle qrStyle = QrStyle.standard,
    Color? fg,
    Color? bg,
    Color? secondaryColor,
    Color? tertiaryColor,
    ImageProvider? logo,
    double size = 300,
    String? filename,
    String? directory,
  }) async {
    try {
      // Generate the options
      final opts = QrBarGenOpts(
        data: data,
        type: type,
        qrStyle: qrStyle,
        size: size,
        fg: fg ?? Colors.black,
        bg: bg ?? Colors.white,
        secondaryColor: secondaryColor,
        tertiaryColor: tertiaryColor,
        logo: logo,
      );

      // Generate the widget
      final widget = QrBarGen.gen(opts);

      // Render to image
      final bytes = await RenderUtils.renderWidget(
        widget: widget,
        size: Size(size, size),
        pixelRatio: 3.0,
      );

      if (bytes == null) return null;

      // Get directory
      Directory outputDir;
      if (directory != null) {
        outputDir = Directory(directory);
        if (!await outputDir.exists()) {
          await outputDir.create(recursive: true);
        }
      } else {
        if (Platform.isAndroid || Platform.isIOS) {
          outputDir = await getApplicationDocumentsDirectory();
        } else {
          outputDir = await getDownloadsDirectory() ??
              await getApplicationDocumentsDirectory();
        }
      }

      // Generate filename
      final name = filename ??
          '${type.label.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}';
      final filePath = '${outputDir.path}/$name.png';

      // Save file
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      return filePath;
    } catch (e) {
      debugPrint('Error saving QR/barcode: $e');
      return null;
    }
  }

  /// Generates a QR code or barcode and shares it with other apps.
  ///
  /// This method creates the code image, saves it to a temporary file,
  /// and then opens the system share sheet to allow the user to share
  /// the image with any app that can handle image files.
  ///
  /// The process happens in these steps:
  /// 1. Generate the code with the provided options
  /// 2. Render it to a high-quality PNG image
  /// 3. Save it to a temporary file
  /// 4. Open the system share dialog with this file
  ///
  /// This is particularly useful for sharing codes via messaging apps,
  /// email, social media, or other communication channels.
  ///
  /// Parameters:
  /// - [data]: The content to encode in the barcode (required)
  /// - [type]: The type of barcode to generate (required)
  /// - [qrStyle]: The visual style for QR codes (ignored for other barcode types)
  /// - [fg], [bg]: Foreground and background colors
  /// - [secondaryColor], [tertiaryColor]: Additional colors for styled QR codes
  /// - [logo]: Optional logo for QR codes with the withLogo style
  /// - [size]: Size of the generated image in logical pixels
  /// - [subject]: Optional subject/title for the share dialog
  ///
  /// Platform behavior:
  /// - On iOS/Android: Opens the native share sheet
  /// - On desktop: Behavior depends on the share_plus package implementation for that platform
  ///
  /// Example:
  /// ```dart
  /// // Share a WiFi connection QR code
  /// await QrExporter.share(
  ///   data: 'WIFI:S:MyNetwork;P:mypassword;;',
  ///   type: QrBarType.qr,
  ///   qrStyle: QrStyle.framed,
  ///   frameColor: Colors.blue,
  ///   subject: 'WiFi QR Code',
  /// );
  ///
  /// // Share a product barcode
  /// await QrExporter.share(
  ///   data: '5901234123457',
  ///   type: QrBarType.ean13,
  ///   subject: 'Product Barcode',
  /// );
  /// ```
  static Future<void> share({
    required String data,
    required QrBarType type,
    QrStyle qrStyle = QrStyle.standard,
    Color? fg,
    Color? bg,
    Color? secondaryColor,
    Color? tertiaryColor,
    ImageProvider? logo,
    double size = 300,
    String? subject,
  }) async {
    try {
      // Create a temporary file
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = await saveToFile(
        data: data,
        type: type,
        qrStyle: qrStyle,
        fg: fg,
        bg: bg,
        secondaryColor: secondaryColor,
        tertiaryColor: tertiaryColor,
        logo: logo,
        size: size,
        filename: 'share_$timestamp',
        directory: tempDir.path,
      );

      if (filePath == null) return;

      // Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: subject ?? '${type.label} Code',
      );
    } catch (e) {
      debugPrint('Error sharing QR/barcode: $e');
    }
  }

  /// Generates a QR code or barcode and returns its raw PNG image data.
  ///
  /// This method renders the code to a PNG image and returns the raw bytes,
  /// allowing for custom handling of the image data without saving it to a file.
  ///
  /// This is particularly useful for:
  /// - Uploading the image to a server
  /// - Embedding the image in a PDF or other document
  /// - Storing the image in a database
  /// - Custom image processing or manipulation
  /// - Implementing custom sharing or exporting logic
  ///
  /// The generated image is high-quality with a 3x pixel ratio by default,
  /// making it suitable for both display and printing purposes.
  ///
  /// Parameters:
  /// - [data]: The content to encode in the barcode (required)
  /// - [type]: The type of barcode to generate (required)
  /// - [qrStyle]: The visual style for QR codes (ignored for other barcode types)
  /// - [fg], [bg]: Foreground and background colors
  /// - [secondaryColor], [tertiaryColor]: Additional colors for styled QR codes
  /// - [logo]: Optional logo for QR codes with the withLogo style
  /// - [size]: Size of the generated image in logical pixels
  ///
  /// Returns a Uint8List containing the PNG image data, or null if an error occurred.
  ///
  /// Example:
  /// ```dart
  /// // Get barcode bytes for uploading to a server
  /// final bytes = await QrExporter.getBytes(
  ///   data: '12345678',
  ///   type: QrBarType.ean13,
  /// );
  /// if (bytes != null) {
  ///   await uploadToServer(bytes);
  /// }
  ///
  /// // Get QR code bytes and convert to base64 for embedding in HTML
  /// final qrBytes = await QrExporter.getBytes(
  ///   data: 'https://flutter.dev',
  ///   type: QrBarType.qr,
  ///   qrStyle: QrStyle.gradient,
  ///   fg: Colors.blue,
  ///   secondaryColor: Colors.purple,
  /// );
  /// if (qrBytes != null) {
  ///   final base64Data = base64Encode(qrBytes);
  ///   final imgHtml = '<img src="data:image/png;base64,$base64Data" />';
  /// }
  /// ```
  static Future<Uint8List?> getBytes({
    required String data,
    required QrBarType type,
    QrStyle qrStyle = QrStyle.standard,
    Color? fg,
    Color? bg,
    Color? secondaryColor,
    Color? tertiaryColor,
    ImageProvider? logo,
    double size = 300,
  }) async {
    try {
      // Generate the options
      final opts = QrBarGenOpts(
        data: data,
        type: type,
        qrStyle: qrStyle,
        size: size,
        fg: fg ?? Colors.black,
        bg: bg ?? Colors.white,
        secondaryColor: secondaryColor,
        tertiaryColor: tertiaryColor,
        logo: logo,
      );

      // Generate the widget
      final widget = QrBarGen.gen(opts);

      // Render to image
      return await RenderUtils.renderWidget(
        widget: widget,
        size: Size(size, size),
        pixelRatio: 3.0,
      );
    } catch (e) {
      debugPrint('Error getting QR/barcode bytes: $e');
      return null;
    }
  }
}
