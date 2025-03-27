import 'package:flutter/material.dart';
import 'package:qrbar/qrbar.dart';

void main() {
  runApp(const QRBarShowcaseApp());
}

// Wrapper app widget that provides MaterialApp
class QRBarShowcaseApp extends StatelessWidget {
  const QRBarShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const QRBarShowcase(),
    );
  }
}

class QRBarShowcase extends StatefulWidget {
  const QRBarShowcase({super.key});

  @override
  State<QRBarShowcase> createState() => _QRBarShowcaseState();
}

class _QRBarShowcaseState extends State<QRBarShowcase> {
  // Display state
  int _currentIndex = 0;

  // Scanning result
  QrBarScanResult? _scanResult;
  bool _isScanning = false;

  // QR Style showcase
  QrStyle _currentStyle = QrStyle.standard;
  final String _demoUrl = 'https://flutter.dev';

  // Colors for styling
  Color _fgColor = Colors.black;
  Color _bgColor = Colors.white;
  Color _secondaryColor = Colors.blue;
  Color _tertiaryColor = Colors.red;

  // Loading state for save/share operations
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QRBar Showcase'), elevation: 2),
      body: Stack(
        children: [
          // Main content
          IndexedStack(
            index: _currentIndex,
            children: [
              _buildQRStylesShowcase(),
              _buildBarcodeTypesShowcase(),
              _buildScannerView(),
            ],
          ),

          // Loading overlay
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Processing...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
          if (index != 2) {
            _isScanning = false; // Stop scanning when switching tabs
          }
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR Styles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Barcode Types',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scanner',
          ),
        ],
      ),
    );
  }

  // QR STYLES SHOWCASE
  Widget _buildQRStylesShowcase() {
    return SafeArea(
      child: Column(
        children: [
          // QR Style display
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Current Style Title
                  Text(
                    _currentStyle.label,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // QR Code Display
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: QrBarGenView(
                      data: _demoUrl,
                      type: QrBarType.qr,
                      qrStyle: _currentStyle,
                      size: 250,
                      fg: _fgColor,
                      bg: _bgColor,
                      secondaryColor: _secondaryColor,
                      tertiaryColor: _tertiaryColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Save & Share buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed:
                            _isProcessing ? null : () => _saveCurrentQR(),
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed:
                            _isProcessing ? null : () => _shareCurrentQR(),
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Style selection
                  const Text(
                    'Select Style:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Style grid
                  LayoutBuilder(builder: (context, constraints) {
                    // Calculate how many items per row based on screen width
                    final double maxWidth = constraints.maxWidth;
                    final int itemsPerRow =
                        maxWidth ~/ 110; // Each item is about 110px wide

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: itemsPerRow,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: QrStyle.values.length,
                      itemBuilder: (context, index) {
                        final style = QrStyle.values[index];
                        return InkWell(
                          onTap: () => setState(() => _currentStyle = style),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: style == _currentStyle
                                  ? Colors.deepPurple.withOpacity(0.1)
                                  : Colors.transparent,
                              border: Border.all(
                                color: style == _currentStyle
                                    ? Colors.deepPurple
                                    : Colors.grey.shade300,
                                width: style == _currentStyle ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: QrBarGenView(
                                    data: 'demo',
                                    type: QrBarType.qr,
                                    qrStyle: style,
                                    secondaryColor: _secondaryColor,
                                    tertiaryColor: _tertiaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  style.label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: style == _currentStyle
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),

                  const SizedBox(height: 20),

                  // Color pickers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildColorPicker(
                        'FG',
                        _fgColor,
                        (c) => setState(() => _fgColor = c),
                      ),
                      const SizedBox(width: 16),
                      _buildColorPicker(
                        'BG',
                        _bgColor,
                        (c) => setState(() => _bgColor = c),
                      ),
                      const SizedBox(width: 16),
                      _buildColorPicker(
                        '2nd',
                        _secondaryColor,
                        (c) => setState(() => _secondaryColor = c),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BARCODE TYPES SHOWCASE
  Widget _buildBarcodeTypesShowcase() {
    final barcodeData = {
      QrBarType.c128: 'ABC-12345-Z',
      QrBarType.ean13: '5901234123457',
      QrBarType.upc: '042100005264',
      QrBarType.pdf417: 'PDF417 Example',
      QrBarType.aztec: 'Aztec Code',
      QrBarType.dm: 'DataMatrix',
    };

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: Text(
              'Supported Barcode Types',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),

          // QR Code Card
          _buildBarcodeCard(
            'QR Code',
            'Two-dimensional matrix code',
            _demoUrl,
            QrBarType.qr,
          ),

          // Other barcode type cards
          ...barcodeData.entries.map(
            (entry) => _buildBarcodeCard(
              entry.key.label,
              entry.key.toString().split('.').last.toUpperCase(),
              entry.value,
              entry.key,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarcodeCard(
    String title,
    String description,
    String data,
    QrBarType type,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(description),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: type == QrBarType.qr ||
                      type == QrBarType.aztec ||
                      type == QrBarType.dm
                  ? 1
                  : 2,
              child: QrBarGenView(data: data, type: type, size: 180),
            ),
            const SizedBox(height: 10),
            Text(
              'Data: $data',
              style: const TextStyle(fontFamily: 'monospace'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      _isProcessing ? null : () => _saveBarcode(data, type),
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed:
                      _isProcessing ? null : () => _shareBarcode(data, type),
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // SCANNER VIEW
  Widget _buildScannerView() {
    return _isScanning ? _buildActiveScannerView() : _buildScanResultView();
  }

  Widget _buildActiveScannerView() {
    return Stack(
      children: [
        // Camera scanner
        QrBarScanView(
          onScan: (result) {
            setState(() {
              _scanResult = result;
              _isScanning = false;
            });
          },
        ),

        // Overlay with instructions
        SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Point camera at any QR code or barcode',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              Container(
                color: Colors.black.withOpacity(0.5),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: TextButton.icon(
                  onPressed: () => setState(() => _isScanning = false),
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text(
                    'Cancel Scan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScanResultView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_scanResult == null) ...[
              const Spacer(),
              const Icon(Icons.qr_code_scanner, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                'No Code Scanned Yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap the button below to start scanning',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _isScanning = true),
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Start Scanning'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ] else ...[
              // Show scan result
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Scan Result',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      // Display the scanned code
                      AspectRatio(
                        aspectRatio: _scanResult!.type == QrBarType.qr ||
                                _scanResult!.type == QrBarType.aztec ||
                                _scanResult!.type == QrBarType.dm
                            ? 1
                            : 2,
                        child: QrBarGenView(
                          data: _scanResult!.value,
                          type: _scanResult!.type,
                          size: 180,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Result information
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildResultRow('Type', _scanResult!.type.label),
                              const Divider(),
                              _buildResultRow('Content', _scanResult!.value),
                              const Divider(),
                              _buildResultRow(
                                  'Time', _formatTime(_scanResult!.time)),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Actions for the scan result
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _isProcessing
                                ? null
                                : () => _shareBarcode(
                                    _scanResult!.value, _scanResult!.type),
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _isScanning = true),
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan Again'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // HELPER METHODS

  // Color picker
  Widget _buildColorPicker(
    String label,
    Color color,
    Function(Color) onSelect,
  ) {
    return Column(
      children: [
        Text(label),
        const SizedBox(height: 4),
        InkWell(
          onTap: () {
            // In a real app, you would use a color picker
            // Here we'll just cycle through some preset colors
            final colors = [
              Colors.black,
              Colors.blue,
              Colors.red,
              Colors.green,
              Colors.purple,
              Colors.orange,
              Colors.teal,
              Colors.pink,
              Colors.white,
            ];

            int index = colors.indexOf(color);
            if (index == -1) index = 0;

            onSelect(colors[(index + 1) % colors.length]);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: Text(
              value,
              softWrap: true,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  // Export functions with loading indicators to avoid focus issues
  void _saveCurrentQR() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final filePath = await QrExporter.saveToFile(
        data: _demoUrl,
        type: QrBarType.qr,
        qrStyle: _currentStyle,
        fg: _fgColor,
        bg: _bgColor,
        secondaryColor: _secondaryColor,
        tertiaryColor: _tertiaryColor,
        filename: 'qrbar_${_currentStyle.toString().split('.').last}',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              filePath != null
                  ? 'Saved to: $filePath'
                  : 'Failed to save QR code',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: filePath != null ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e', maxLines: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _shareCurrentQR() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await QrExporter.share(
        data: _demoUrl,
        type: QrBarType.qr,
        qrStyle: _currentStyle,
        fg: _fgColor,
        bg: _bgColor,
        secondaryColor: _secondaryColor,
        tertiaryColor: _tertiaryColor,
        subject: 'QR Code with ${_currentStyle.label} style',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e', maxLines: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _saveBarcode(String data, QrBarType type) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final filePath = await QrExporter.saveToFile(
        data: data,
        type: type,
        filename: '${type.toString().split('.').last}_example',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              filePath != null
                  ? 'Saved to: $filePath'
                  : 'Failed to save barcode',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: filePath != null ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e', maxLines: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _shareBarcode(String data, QrBarType type) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await QrExporter.share(
        data: data,
        type: type,
        subject: '${type.label} Example',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e', maxLines: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}
