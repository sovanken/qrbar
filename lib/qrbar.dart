// ignore_for_file: unnecessary_library_name

/// QRBar: A comprehensive Flutter package for barcode generation and scanning.
///
/// QRBar provides a complete solution for working with QR codes and barcodes in Flutter
/// applications. It offers a clean, unified API for both generating visually appealing
/// codes and scanning them using the device camera, with extensive customization options.
///
/// ## Key Features
///
/// ### Barcode Generation
/// - Create QR codes and multiple 1D/2D barcode formats as Flutter widgets
/// - 10 unique QR code styles with different visual appearances
/// - Extensive customization with colors, logos, frames, and effects
/// - Simple widget-based API that integrates with standard Flutter layouts
///
/// ### Code Scanning
/// - Camera-based scanning of all supported barcode formats
/// - Clean callback-based API for handling scan results
/// - Support for continuous scanning or single-scan modes
/// - Automatic format detection and conversion
///
/// ### Export Capabilities
/// - Save generated codes as PNG images to the device
/// - Share codes directly to other apps via the system share sheet
/// - Get raw image bytes for custom handling and network operations
///
/// ### Supported Formats
/// - QR Code (2D)
/// - Code 128 (1D)
/// - EAN-13 (1D)
/// - UPC-A (1D)
/// - PDF417 (2D stacked linear)
/// - Aztec Code (2D)
/// - Data Matrix (2D)
///
/// ## Usage Examples
///
/// ### Generating and Displaying a QR Code
///
/// ```dart
/// // Basic QR code
/// QrBarGenView(
///   data: 'https://flutter.dev',
///   type: QrBarType.qr,
/// )
///
/// // Styled QR code with gradient effect
/// QrBarGenView(
///   data: 'https://flutter.dev',
///   type: QrBarType.qr,
///   qrStyle: QrStyle.gradient,
///   fg: Colors.purple,
///   secondaryColor: Colors.blue,
///   size: 250,
/// )
/// ```
///
/// ### Scanning Barcodes
///
/// ```dart
/// QrBarScanView(
///   onScan: (result) {
///     // Handle the scan result
///     print('Scanned: ${result.value}');
///     print('Format: ${result.type.label}');
///
///     // Check the code type and handle accordingly
///     if (result.type == QrBarType.qr) {
///       if (result.value.startsWith('http')) {
///         launchUrl(Uri.parse(result.value));
///       }
///     } else if (result.type == QrBarType.ean13) {
///       lookupProduct(result.value);
///     }
///   },
/// )
/// ```
///
/// ### Exporting QR Codes
///
/// ```dart
/// // Save to file
/// final path = await QrExporter.saveToFile(
///   data: 'https://flutter.dev',
///   type: QrBarType.qr,
///   qrStyle: QrStyle.framed,
///   frameColor: Colors.blue,
/// );
///
/// // Share with other apps
/// await QrExporter.share(
///   data: 'WIFI:S:MyNetwork;P:password123;;',
///   type: QrBarType.qr,
///   subject: 'WiFi Connection',
/// );
/// ```
///
/// ## Package Organization
///
/// The package is structured around these core components:
///
/// - **Models**: Data structures for types, options, and results ([QrBarType], [QrStyle], etc.)
/// - **Generators**: Widgets and utilities for creating codes ([QrBarGenView], [QrBarGen])
/// - **Scanner**: Camera-based code scanning components ([QrBarScanView])
/// - **Exporters**: Utilities for saving and sharing codes ([QrExporter])
///
/// ## Getting Started
///
/// Add the dependency to your pubspec.yaml:
///
/// ```yaml
/// dependencies:
///   qrbar: ^1.0.0
/// ```
///
/// Import the package:
///
/// ```dart
/// import 'package:qrbar/qrbar.dart';
/// ```
///
/// For more detailed examples and API documentation, visit the package
/// documentation or the project repository.
library qrbar;

export 'models/code_type.dart';
export 'models/scan_result.dart';
export 'models/generate_options.dart';
export 'models/qr_style.dart';

export 'src/generator/generator.dart';
export 'src/generator/generator_widget.dart';
export 'src/generator/custom_qr_painters.dart';

export 'src/scanner/scanner.dart';

export 'src/utils/qr_exporter.dart';
