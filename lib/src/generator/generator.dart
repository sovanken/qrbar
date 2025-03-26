import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';

import '../../models/code_type.dart';
import '../../models/generate_options.dart';

/// Core utility for generating QR codes or barcodes based on [QrBarGenOpts].
///
/// This class converts generation options into the corresponding widget
/// for rendering the specified code type.
class QrBarGen {
  /// Generates a [Widget] for the specified QR or barcode type.
  ///
  /// The appearance and type are controlled by the provided [opts].
  ///
  /// Example usage:
  /// ```dart
  /// QrBarGen.gen(QrBarGenOpts(data: 'Hello', type: QrBarType.qr));
  /// ```
  static Widget gen(QrBarGenOpts opts) {
    switch (opts.type) {
      case QrBarType.qr:
        return QrImageView(
          data: opts.data,
          version: QrVersions.auto,
          size: opts.size,
          backgroundColor: opts.bg,
          eyeStyle: QrEyeStyle(color: opts.fg),
          dataModuleStyle: QrDataModuleStyle(color: opts.fg),
        );

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
}
