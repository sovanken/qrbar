// ignore_for_file: unnecessary_library_name

/// A Flutter package for scanning and generating QR codes and barcodes.
///
/// This library exports all core models, widgets, and tools for working with
/// QR and barcodes in a Flutter app using a clean and unified API.
///
/// ✅ Scan barcodes using camera
/// ✅ Generate codes as widgets
/// ✅ Customizable styling and formats
/// ✅ Supports QR, Code128, EAN13, UPC, PDF417, Aztec, DataMatrix
library qrbar;

export 'models/code_type.dart';
export 'models/scan_result.dart';
export 'models/generate_options.dart';

export 'src/generator/generator.dart';
export 'src/generator/generator_widget.dart';

export 'src/scanner/scanner.dart';
