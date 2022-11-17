import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class BarCode extends StatefulWidget {
  const BarCode({Key? key}) : super(key: key);

  @override
  _BarCodeState createState() => _BarCodeState();
}

class _BarCodeState extends State<BarCode> {
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
    if(codigo!.length == 44){
      controller!.stopCamera();
      Navigator.pushReplacementNamed(context, "/enviaCodigo", arguments: codigo);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: GestureDetector(
      //   child: Container(
      //     width: 250,
      //     height: 50.0,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.only(left: 64.0, right: 16.0),
      //           child: Icon(Icons.keyboard, color: Colors.green,),
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.only(left: 16.0, right: 64.0),
      //           child: Text("Digitar", style: TextStyle(fontSize: 16, color: Colors.green),),
      //         )
      //       ],
      //     ),
      //     decoration: BoxDecoration(
      //         color: Colors.white,
      //         borderRadius: BorderRadius.circular(8)
      //     ),
      //   ),
      //   onTap: (){
      //     Navigator.pushReplacementNamed(context, "/digitarCodigo");
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.green,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset("assets/img/logo.png",
          width: 50,
          height: 50,
        ),
        // title: GestureDetector(
        //   child: FutureBuilder(
        //     future: controller?.getCameraInfo(),
        //     builder: (context, snapshot) {
        //       if (snapshot.data != null) {
        //         return Icon(Icons.camera_alt, color: Colors.white,);
        //       } else {
        //         return const Text('carregando');
        //       }
        //     },
        //   ),
        //   onTap: () async {
        //     await controller?.flipCamera();
        //     setState(() {});
        //   },
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              child: FutureBuilder(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  return Icon(Icons.flash_on, color: Colors.white,);
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
      floatingActionButton: HawkFabMenu(
        body: const Center(
          child: null,
        ),
        icon: AnimatedIcons.view_list,
        fabColor: Colors.green,
        iconColor: Colors.white,
        items: [
          HawkFabMenuItem(
            label: 'Ler Cód. barras',
            ontap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.pushReplacementNamed(context, "/barCodeSimples");
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Menu 1 selected')),
              // );
            },
            icon: Icon(Icons.camera_alt_outlined),
            color: Colors.green,
            labelColor: Colors.black,
            labelBackgroundColor: Colors.white,
          ),
          HawkFabMenuItem(
            label: 'Ler QR Code',
            ontap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.pushReplacementNamed(context, "/scan");
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Menu 2 selected')),
              // );
            },
            icon: const Icon(Icons.qr_code),
            color: Colors.green,
            labelColor: Colors.black,
            labelBackgroundColor: Colors.white,
          ),
          HawkFabMenuItem(
            label: 'Cód. Barras Duplo',
            ontap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.pushReplacementNamed(context, "/barCode");
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Menu 3 selected')),
              // );
            },
            icon: const Icon(Icons.add_a_photo_outlined),
            color: Colors.green,
            labelColor: Colors.black,
            labelBackgroundColor: Colors.white,
          ),
          HawkFabMenuItem(
            label: 'Digitar Cód. Barras',
            ontap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.pushReplacementNamed(context, "/digitarCodigo");
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Menu 3 selected')),
              // );
            },
            icon: const Icon(Icons.keyboard),
            color: Colors.green,
            labelColor: Colors.black,
            labelBackgroundColor: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 4,
              child: _buildQrView(context)
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 400.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      // formatsAllowed: [
      //   BarcodeFormat.code93
      // ],
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 0,
          borderLength: 60,
          borderWidth: 10,
          cutOutWidth: 400,
          cutOutHeight: 100
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      enviaPraProximaTela(result!.code!);
    });

  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  // void _onQRViewCreated(QRViewController controller) {
  //
  //   setState(() {
  //     this.controller = controller;
  //   });
  //
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       result = scanData;
  //     });
  //     Navigator.pushNamed(context, '/enviaCodigo', arguments: result!.code);
  //   });
  // }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    //log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sem Permissão')),
      );
    }
  }
}
