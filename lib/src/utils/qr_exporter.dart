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
      // Use a microtask to avoid focus conflicts
      Uint8List? bytes = await Future.microtask(() async {
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
      });

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
      // Use a microtask to avoid focus conflicts
      await Future.microtask(() async {
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

        // Share the file - using a separate microtask to avoid focus conflicts
        await Future.microtask(() async {
          await Share.shareXFiles(
            [XFile(filePath)],
            subject: subject ?? '${type.label} Code',
          );
        });
      });
    } catch (e) {
      debugPrint('Error sharing QR/barcode: $e');
    }
  }

  /// Generates a QR code or barcode and returns its raw PNG image data.
  ///
  /// This method renders the code to a PNG image and returns the raw bytes,
  /// allowing for custom handling of the image data without saving it to a file.
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
      // Use a microtask to avoid focus conflicts
      return await Future.microtask(() async {
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
      });
    } catch (e) {
      debugPrint('Error getting QR/barcode bytes: $e');
      return null;
    }
  }
}
