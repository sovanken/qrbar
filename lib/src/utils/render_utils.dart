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
class RenderUtils {
  /// Renders a Flutter widget to a PNG image and returns the raw bytes.
  ///
  /// This method creates a virtual render environment that allows widgets
  /// to be rendered without being part of the visible widget tree. It sets
  /// up necessary rendering infrastructure while avoiding focus system conflicts.
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
  static Future<Uint8List?> widgetToImage({
    required Widget widget,
    required double width,
    required double height,
    double pixelRatio = 3.0,
  }) async {
    try {
      // Create a simple render pipeline with just a SizedBox wrapper
      // This avoids creating a whole new MaterialApp instance
      final wrappedWidget = MediaQuery(
        data: const MediaQueryData(),
        child: SizedBox(
          width: width,
          height: height,
          child: widget,
        ),
      );

      // Create a repaint boundary to capture the widget
      final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

      // Use a minimal PipelineOwner to avoid focus conflicts
      final PipelineOwner pipelineOwner = PipelineOwner();
      final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

      // Create the render element
      final RenderObjectToWidgetElement<RenderBox> element =
          RenderObjectToWidgetAdapter<RenderBox>(
        container: repaintBoundary,
        child: wrappedWidget,
      ).attachToRenderTree(buildOwner);

      // Perform layout in a way that avoids focus conflicts
      // Use microtask to ensure we're not interfering with ongoing frame processing
      await Future.microtask(() {
        buildOwner.buildScope(element);
        buildOwner.finalizeTree();
      });

      // Layout the boundary with appropriate constraints
      repaintBoundary.layout(BoxConstraints(
        maxWidth: width,
        maxHeight: height,
      ));

      // Capture the image
      final ui.Image image =
          await repaintBoundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      // Clean up resources
      pipelineOwner.rootNode = null;

      // Return the result
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
