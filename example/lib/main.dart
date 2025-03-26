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

class QrBarHomePage extends StatefulWidget {
  const QrBarHomePage({super.key});

  @override
  State<QrBarHomePage> createState() => _QrBarHomePageState();
}

class _QrBarHomePageState extends State<QrBarHomePage> {
  String? scanValue;
  String? scanType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Generated QR Code:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Center(
                child: QrBarGenView(
                  data: 'https://example.com',
                  type: QrBarType.qr,
                  size: 200,
                ),
              ),
              const SizedBox(height: 36),
              const Text(
                'Generated Barcode (Code 128):',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Center(
                child: QrBarGenView(
                  data: '1234567890',
                  type: QrBarType.c128,
                  size: 200,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push<QrBarScanResult>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QrBarScannerScreen(),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        scanValue = result.value;
                        scanType = result.type.label;
                      });
                    }
                  },
                  icon: const Icon(Icons.qr_code_scanner, size: 24),
                  label: const Text(
                    'Scan Code',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (scanValue != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    border: Border.all(color: Colors.teal.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Scan Result:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Value: $scanValue',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Type: $scanType',
                        style: const TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
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
      appBar: AppBar(
        title: const Text('QR/Barcode Scanner'),
        centerTitle: true,
      ),
      body: QrBarScanView(
        onScan: (QrBarScanResult result) {
          Navigator.of(context).pop(result);
        },
      ),
    );
  }
}
