import 'package:flutter/material.dart';

class ScanBandQrScreen extends StatefulWidget {
  const ScanBandQrScreen({super.key});

  @override
  State<ScanBandQrScreen> createState() => _ScanBandQrScreenState();
}

class _ScanBandQrScreenState extends State<ScanBandQrScreen> {
  bool _showCamera = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Band QR')),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Big square section for QR scanning
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Adjust the radius as needed
                ),
                child: _buildQrScanArea(),
              ),

              // Container(
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     color: Theme.of(context).colorScheme.surface,
              //     borderRadius: BorderRadius.circular(16),
              //     border: Border.all(
              //       color: Theme.of(context).primaryColor,
              //       width: 2,
              //     ),
              //   ),
              //   child: _buildQrScanArea(),
              // ),
            ),

            const SizedBox(height: 24),

            // Step-by-step instructions
            Expanded(flex: 2, child: _buildInstructions()),
          ],
        ),
      ),
    );
  }

  Widget _buildQrScanArea() {
    if (_showCamera) {
      return _buildCameraViewfinder();
    }

    return Center(
      child: IconButton(
        icon: const Icon(Icons.qr_code_scanner_outlined, size: 96),
        // color: Colors.black87,
        onPressed: () => () {
          setState(() {
            _showCamera = true;
          });
        },
      ),
    );
    // return Center(
    //   child: ElevatedButton(
    //     style: ElevatedButton.styleFrom(
    //       // backgroundColor: Theme.of(context).primaryColor,
    //       // foregroundColor: Theme.of(context).colorScheme.onPrimary,
    //       backgroundColor: Theme.of(context).colorScheme.onPrimary,
    //       foregroundColor: Theme.of(context).primaryColor,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(12),
    //       ),
    //       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    //     ),
    //     onPressed: () {
    //       setState(() {
    //         _showCamera = true;
    //       });
    //     },
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: const [
    //         Icon(Icons.qr_code_scanner_outlined, size: 48),
    //         // SizedBox(height: 12),
    //         // Text(
    //         //   'Scan QR',
    //         //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //         // ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _buildCameraViewfinder() {
    return Stack(
      children: [
        // Simulated camera viewfinder (in real app, this would be a camera widget)
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: const Center(
            child: Text(
              'Camera Viewfinder',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),

        // Overlay with scanning frame
        _buildScanOverlay(),

        // Close button
        Positioned(
          top: 16,
          right: 16,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.9),
              foregroundColor: Colors.black,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
            ),
            onPressed: () {
              setState(() {
                _showCamera = false;
              });
            },
            child: const Icon(Icons.close, size: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildScanOverlay() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Corner indicators
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8)),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8)),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How to Join a Band',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInstructionStep(
              1,
              'Request the band QR code from the band lead',
              'The band lead will need to generate a QR code from their band settings to invite you to join their band.',
            ),
            const SizedBox(height: 12),
            _buildInstructionStep(
              2,
              'Scan the QR code to add yourself into the band',
              'Use the scanner above to scan the QR code provided by the band lead. This will automatically send a join request to the band.',
            ),
            const SizedBox(height: 12),
            _buildInstructionStep(
              3,
              'Wait for approval from the band lead',
              'Once you scan the QR code, the band lead will receive your join request and can approve or decline it.',
            ),
            const SizedBox(height: 16),
            Text(
              'Note: Make sure you have permission from the band lead before scanning their QR code.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(
    int stepNumber,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              stepNumber.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(description, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
