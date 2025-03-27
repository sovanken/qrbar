import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Specialized utility for rendering Flutter widgets to high-quality PNG images.
///
/// This utility class provides methods to convert any Flutter widget into PNG image data
/// without needing to display it on screen. It uses Flutter's rendering pipeline to
/// create offscreen renderings that can be exported as image bytes.
///
/// Key capabilities:
/// - Render any Flutter widget to PNG image bytes
/// - Control image dimensions and resolution
/// - Support for transparent backgrounds
/// - Detailed error handling and logging
///
/// This class is primarily used internally by [QrExporter] to convert generated
/// barcode widgets into images that can be saved or shared, but it can also be
/// used directly for custom rendering needs.
///
/// Example usage:
/// ```dart
/// // Create a widget to render
/// final widget = Container(
///   padding: EdgeInsets.all(16),
///   color: Colors.blue,
///   child: Text('Hello World', style: TextStyle(color: Colors.white)),
/// );
///
/// // Render it to image bytes
/// final bytes = await RenderUtils.renderWidget(
///   widget: widget,
///   size: Size(300, 100),
///   pixelRatio: 2.0,
/// );
///
/// if (bytes != null) {
///   // Use the image bytes (save to file, upload to server, etc.)
/// }
/// ```
///
/// The rendering process handles all the complexity of setting up a proper
/// render tree, layout, and painting pipeline without actually displaying
/// anything on screen, making it suitable for background processing.
class RenderUtils {
  /// Renders a Flutter widget to a PNG image and returns the raw bytes.
  ///
  /// This method creates a virtual render environment that allows widgets
  /// to be rendered without being part of the visible widget tree. It sets
  /// up all the necessary rendering infrastructure, performs layout and painting,
  /// and then captures the result as a PNG image.
  ///
  /// This approach handles complex widget trees and ensures proper rendering
  /// of all Flutter widgets, including those that depend on MaterialApp context.
  ///
  /// Parameters:
  /// - [widget]: The Flutter widget to render. This can be any valid widget.
  /// - [width]: The width at which to render the widget, in logical pixels.
  /// - [height]: The height at which to render the widget, in logical pixels.
  /// - [pixelRatio]: The device pixel ratio to use for rendering, controlling the
  ///   resolution of the output image. Higher values produce larger, more detailed images.
  ///   Default is 3.0, which is suitable for high-resolution displays and printing.
  ///
  /// Returns a [Uint8List] containing the raw PNG image data, or null if rendering failed.
  /// The returned bytes can be directly written to a file, used with Image.memory,
  /// or processed further.
  ///
  /// Technical details:
  /// - Creates a MaterialApp wrapper to ensure proper theming and navigation context
  /// - Uses RenderRepaintBoundary to isolate the rendering
  /// - Performs a full layout pass to correctly position all elements
  /// - Captures the rendered output at the specified pixel ratio
  /// - Converts the raw image data to PNG format
  ///
  /// Example:
  /// ```dart
  /// final customWidget = Row(
  ///   children: [
  ///     Icon(Icons.qr_code, size: 40),
  ///     Text('Scan me!', style: TextStyle(fontSize: 20)),
  ///   ],
  /// );
  ///
  /// final bytes = await RenderUtils.widgetToImage(
  ///   widget: customWidget,
  ///   width: 200,
  ///   height: 50,
  ///   pixelRatio: 2.5,
  /// );
  /// ```
  static Future<Uint8List?> widgetToImage({
    required Widget widget,
    required double width,
    required double height,
    double pixelRatio = 3.0,
  }) async {
    // Create a wrapping widget to set the correct size
    final wrappedWidget = MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: width,
          height: height,
          child: widget,
        ),
      ),
    );

    // Use a RepaintBoundary to capture the widget
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    // Create a simple render tree with the widget
    final BuildOwner buildOwner = BuildOwner();
    final RenderObjectToWidgetElement<RenderBox> element =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: wrappedWidget,
    ).attachToRenderTree(buildOwner);

    // Perform a layout pass
    buildOwner.buildScope(element);
    buildOwner.finalizeTree();

    // Prepare the render tree for capture
    final BoxConstraints constraints = BoxConstraints(
      maxWidth: width,
      maxHeight: height,
    );
    repaintBoundary.layout(constraints);

    try {
      // Capture the image with the specified pixel ratio
      final ui.Image image =
          await repaintBoundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        return byteData.buffer.asUint8List();
      }
    } catch (e) {
      debugPrint('Error rendering widget to image: $e');
    }

    return null;
  }

  /// A simplified method for rendering widgets to PNG images using a Size object.
  ///
  /// This convenience method wraps the more detailed [widgetToImage] function,
  /// allowing the dimensions to be specified as a single [Size] object rather
  /// than separate width and height parameters.
  ///
  /// Parameters:
  /// - [widget]: The Flutter widget to render
  /// - [size]: A Size object specifying width and height for the rendering
  /// - [pixelRatio]: The device pixel ratio to use (higher values = more detail)
  ///
  /// Returns a [Uint8List] containing the PNG image data, or null if rendering failed.
  ///
  /// This method is particularly useful when working with code that already has
  /// Size objects, such as layout calculations or when rendering widgets that
  /// have an intrinsic size.
  ///
  /// Example:
  /// ```dart
  /// // Render a QR code widget to an image
  /// final qrWidget = QrBarGenView(
  ///   data: 'https://example.com',
  ///   type: QrBarType.qr,
  /// );
  ///
  /// final size = Size(200, 200);
  /// final bytes = await RenderUtils.renderWidget(
  ///   widget: qrWidget,
  ///   size: size,
  /// );
  /// ```
  static Future<Uint8List?> renderWidget({
    required Widget widget,
    required Size size,
    double pixelRatio = 3.0,
  }) {
    return widgetToImage(
      widget: widget,
      width: size.width,
      height: size.height,
      pixelRatio: pixelRatio,
    );
  }
}
