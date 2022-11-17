import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/flutter_qr_bar_scanner.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  String? _qrInfo = 'Scan a QR/Bar code';
  bool _camState = false;

  _qrCallback(String? codigo) {
    var codigoTratado = codigo!.split('|')[0].trim().toLowerCase().replaceAll("cfe", "");
    if(codigoTratado.length == 44){
      setState(() {
        _camState = false;
        _qrInfo = codigo;
      });
      Navigator.pushReplacementNamed(context, "/enviaCodigo", arguments: codigoTratado);
    }
  }

  _scanCode() {
    setState(() {
      _camState = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _scanCode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              setState(() {
                _camState = false;
              });
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
              setState(() {
                _camState = false;
              });
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
              setState(() {
                _camState = false;
              });
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
              setState(() {
                _camState = false;
              });
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
      body: _camState
          ? Center(
        child: SizedBox(
          height: 1000,
          width: 500,
          child: QRBarScannerCamera(
            formats: [
             BarcodeFormats.QR_CODE
            ],
            qrCodeCallback: (code) {
              _qrCallback(code);
            },
            child: Container(
              child: Center(
                child: Stack(
                  fit: StackFit.loose,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 4.0,
                            style: BorderStyle.solid,
                          ),
                        borderRadius: BorderRadius.circular(16)
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      )
          : Center(
            child: Container(),
      ),
    );
  }
}
