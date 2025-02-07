import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:order_track/core/utils/utils.dart';
import 'package:order_track/features/client/presentation/bloc/client_bloc.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Order QR Code'),
      ),
      body: ReaderWidget(
        allowPinchZoom: false,
        showGallery: false,
        onScan: (result) async {
          Utils.logInfo("SCAN: ${result.text}");
          if (result.text != null) {
            // Handle the scanned QR code result
            final orderId = result.text!;
            // Send confirmation of the received order
            context
                .read<ClientBloc>()
                .add(ConfirmOrderReceivedEvent(orderId: orderId));

            // Show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Order $orderId confirmed!')),
            );

            // Navigate back to the previous screen
            if (context.mounted) {
              Navigator.of(context)
                  .pop(true); // Pass `true` to indicate a refresh is needed
            }
          }
        },
      ),
    );
  }
}
