import 'package:flutter/material.dart';
import 'package:qrbar/qrbar.dart';

void main() {
  runApp(const QrBarExampleApp());
}

class QrBarExampleApp extends StatelessWidget {
  const QrBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'qrbar Example',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const QrBarHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QrBarHomePage extends StatelessWidget {
  const QrBarHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('qrbar Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Generated QR Code:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            QrBarGenView(
              data: 'https://example.com',
              type: QrBarType.qr,
              size: 200,
            ),
            const SizedBox(height: 32),
            const Text(
              'Generated Barcode (Code 128):',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            QrBarGenView(data: '1234567890', type: QrBarType.c128, size: 200),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QrBarScannerScreen()),
                );
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Open Scanner'),
            ),
          ],
        ),
      ),
    );
  }
}

class QrBarScannerScreen extends StatelessWidget {
  const QrBarScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR/Barcode Scanner')),
      body: QrBarScanView(
        onScan: (QrBarScanResult result) {
          Navigator.pop(context); // Close scanner screen
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text('Scan Result'),
                  content: Text(
                    'Value: ${result.value}\nType: ${result.type.label}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        },
      ),
    );
  }
}
