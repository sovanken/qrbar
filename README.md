# 📦 QRBar

**QRBar** is a comprehensive Flutter package for scanning and generating QR codes and barcodes. It provides a unified API with extensive customization options and advanced styling features.

## ✨ Features

### 🎨 Barcode Generation
- Create QR codes and multiple 1D/2D barcode formats as Flutter widgets
- 10 unique QR code styles with different visual appearances
- Extensive customization with colors, logos, frames, and effects
- Simple widget-based API that integrates seamlessly with standard Flutter layouts

### 📷 Code Scanning
- Camera-based scanning of all supported barcode formats
- Clean callback-based API for handling scan results
- Support for continuous scanning or single-scan modes
- Automatic format detection and conversion

### 🔄 Supported Formats
- QR Code (2D)
- Code 128 (1D)
- EAN-13 (1D)
- UPC-A (1D)
- PDF417 (2D stacked linear)
- Aztec Code (2D)
- Data Matrix (2D)


## ✅ Platform Support

| Platform | Generate | Scan |
|----------|----------|------|
| Android  | ✅        | ✅    |
| iOS      | ✅        | ✅    |
| Web      | ✅        | ❌    |
| Windows  | ✅        | ❌    |
| macOS    | ✅        | ❌    |
| Linux    | ✅        | ❌    |

> ⚠️ Camera-based scanning is only supported on **Android** and **iOS**.

---

## 🚀 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  qrbar: ^0.0.7
```

Then run:

```bash
flutter pub get
```

---

## ⚙️ Platform Setup

### For Scanning (Android & iOS)

#### Android

In `android/app/src/main/AndroidManifest.xml`, add:

```xml
<uses-permission android:name="android.permission.CAMERA" />
```

#### iOS

In `ios/Runner/Info.plist`, add:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for scanning QR and barcodes.</string>
```

---

## 💡 Usage Examples

### Generating and Displaying a QR Code

```dart
// Basic QR code
QrBarGenView(
  data: 'https://flutter.dev',
  type: QrBarType.qr,
)

// Styled QR code with gradient effect
QrBarGenView(
  data: 'https://flutter.dev',
  type: QrBarType.qr,
  qrStyle: QrStyle.gradient,
  fg: Colors.purple,
  secondaryColor: Colors.blue,
  size: 250,
)

// Generate a barcode
QrBarGenView(
  data: '5901234123457',
  type: QrBarType.ean13,
  size: 200,
)
```

### Scanning Barcodes

```dart
QrBarScanView(
  onScan: (result) {
    // Handle the scan result
    print('Scanned: ${result.value}');
    print('Format: ${result.type.label}');
    
    // Check the code type and handle accordingly
    if (result.type == QrBarType.qr) {
      if (result.value.startsWith('http')) {
        launchUrl(Uri.parse(result.value));
      }
    } else if (result.type == QrBarType.ean13) {
      lookupProduct(result.value);
    }
  },
  allowMulti: true, // Enables continuous scanning
)
```

---

## 🧩 Advanced Styling

QRBar provides 10 different visual styles for QR codes:

```dart
enum QrStyle {
  standard,    // Classic QR code
  rounded,     // QR code with rounded data modules
  withLogo,    // QR code with a center logo
  gradient,    // QR code with color gradient
  fancyEyes,   // Custom colored eye patterns
  dots,        // Dots instead of squares
  framed,      // QR with decorative frame
  shadow,      // QR with drop shadow
  mosaic,      // Checkerboard pattern
  pixelArt,    // Retro pixel art style
}
```

Each style supports various customization options:

```dart
QrBarGenView(
  data: 'https://flutter.dev',
  type: QrBarType.qr,
  qrStyle: QrStyle.gradient,
  fg: Colors.blue,          // Primary color
  secondaryColor: Colors.purple,  // Secondary color for gradient
  size: 250,
)
```

For the `withLogo` style, provide an image:

```dart
QrBarGenView(
  data: 'https://flutter.dev',
  type: QrBarType.qr,
  qrStyle: QrStyle.withLogo,
  logo: AssetImage('assets/logo.png'),
)
```

---

## 🧱 API Reference

### QrBarType

```dart
enum QrBarType {
  qr,      // QR Code (2D)
  c128,    // Code 128 (1D)
  ean13,   // EAN-13 (1D)
  upc,     // UPC-A (1D)
  pdf417,  // PDF417 (2D stacked linear)
  aztec,   // Aztec Code (2D)
  dm,      // Data Matrix (2D)
}
```

### QrBarGenOpts

```dart
class QrBarGenOpts {
  final String data;           // Content to encode
  final QrBarType type;        // Code format to generate
  final double size;           // Size of the generated code
  final Color bg;              // Background color
  final Color fg;              // Foreground color
  final QrStyle qrStyle;       // Style for QR codes
  final ImageProvider? logo;   // Logo for withLogo style
  final Color? secondaryColor; // Secondary color for gradients
  final Color? tertiaryColor;  // Tertiary color for pixelArt
  final Color? frameColor;     // Frame color 
  final double frameWidth;     // Frame width
  final Color? shadowColor;    // Shadow color
  final Offset shadowOffset;   // Shadow offset
  final double shadowBlurRadius; // Shadow blur
}
```

### QrBarScanResult

```dart
class QrBarScanResult {
  final String value;     // The decoded data
  final QrBarType type;   // Format of the scanned code
  final DateTime time;    // Timestamp of the scan
}
```

---

## 📄 License

MIT License © 2025 [Sovanken](https://github.com/sovanken)
```

