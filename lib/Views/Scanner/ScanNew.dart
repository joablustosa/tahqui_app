import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class ScanNew extends StatefulWidget {
  const ScanNew({Key? key}) : super(key: key);

  @override
  _ScanNewState createState() => _ScanNewState();
}

class _ScanNewState extends State<ScanNew> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  enviaPraProximaTela(String? codigo){
    var codigoTratado = codigo!.split('|')[0].trim();
    controller!.stopCamera();
    Navigator.pop(context);
    Navigator.pushNamed(context, "/enviaCodigo", arguments: codigoTratado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.green, //change your color here
        ),
        title: Image.asset("assets/img/logo.png",
          width: 50,
          height: 50,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              child: FutureBuilder(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    return Icon(Icons.flash_on, color: Colors.green,);
                  },
              ),
              onTap: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      formatsAllowed: [
        BarcodeFormat.qrcode
      ],
      overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

    void _onQRViewCreated(QRViewController controller) {

      this.controller = controller;

      controller.scannedDataStream.listen((scanData) {
        setState(() {
          result = scanData;
        });
        if(result!.code!.length >= 44){
          enviaPraProximaTela(result!.code!);
        }
      });

    }

    @override
    void dispose() {
      controller?.dispose();
      super.dispose();
    }
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sem Permissão')),
      );
    }
  }
}
