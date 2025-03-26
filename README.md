
# 📦 qrbar

**qrbar** is a lightweight Flutter package for scanning and generating QR codes and barcodes.  
It wraps common functionality into a clean, unified API — making it easy to integrate with any Flutter app.

---

## ✨ Features

- 📷 Scan QR codes and various barcodes using the device camera
- 🧾 Generate QR codes or barcodes as Flutter widgets
- 🎨 Customizable output: size, foreground/background color
- 🔒 Clean and minimal API with no third-party exposure
- 🔁 Supports multiple formats including `QR`, `Code128`, `EAN13`, `UPC`, `PDF417`, `Aztec`, `DataMatrix`

---

## ✅ Platform Support

| Platform | Generate | Scan |
|----------|----------|------|
| Android  | ✅        | ✅    |
| iOS      | ✅        | ✅    |
| Web      | ✅ (QR only) | ❌ |
| Windows  | ✅ (QR only) | ❌ |
| macOS    | ✅ (QR only) | ❌ |
| Linux    | ✅ (QR only) | ❌ |

> ⚠️ Camera-based scanning is only supported on **Android** and **iOS**.

---

## 🚀 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  qrbar: ^0.0.1
```

Then run:

```bash
flutter pub get
```

---

## ⚙️ Platform Setup (for Scanning)

### Android

In `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<application>
  ...
</application>
```

In `android/app/build.gradle`:

```gradle
minSdkVersion 21
```

---

### iOS

In `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for scanning QR and barcodes.</string>
```

---

## 💡 Quick Usage

### Generate a QR Code

```dart
import 'package:qrbar/qrbar.dart';

QrBarGenView(
  data: 'https://example.com',
  type: QrBarType.qr,
  size: 200,
);
```

### Generate a Barcode

```dart
QrBarGenView(
  data: '1234567890',
  type: QrBarType.c128,
  size: 200,
);
```

### Scan a QR or Barcode

```dart
QrBarScanView(
  onScan: (QrBarScanResult result) {
    print('Scanned: ${result.value} (${result.type.label})');
  },
);
```

---

## 🧱 API Reference

### Code Type

```dart
enum QrBarType {
  qr, c128, ean13, upc, pdf417, aztec, dm
}
```

### Generator Config

```dart
class QrBarGenOpts {
  final String data;
  final QrBarType type;
  final double size;
  final Color bg;
  final Color fg;
}
```

### Scan Result

```dart
class QrBarScanResult {
  final String value;
  final QrBarType type;
  final DateTime time;
}
```

---

## 📂 Example App

A full working demo is available in the [`example/`](example) folder.

---

## 🔗 Repository

[github.com/sovanken/qrbar](https://github.com/sovanken/qrbar)

---

## 📄 License

MIT License © 2025 [Sovanken](https://github.com/sovanken)
```
