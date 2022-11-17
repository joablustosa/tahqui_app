import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DigitarCodigo extends StatefulWidget {
  const DigitarCodigo({Key? key}) : super(key: key);

  @override
  _DigitarCodigoState createState() => _DigitarCodigoState();
}

class _DigitarCodigoState extends State<DigitarCodigo> {
  final _controllerCodigo = TextEditingController();
  final _controllerCodigo1 = TextEditingController();
  final _controllerCodigo2 = TextEditingController();
  final _controllerCodigo3 = TextEditingController();
  final _controllerCodigo4 = TextEditingController();
  final _controllerCodigo5 = TextEditingController();
  final _controllerCodigo6 = TextEditingController();
  final _controllerCodigo7 = TextEditingController();
  final _controllerCodigo8 = TextEditingController();
  final _controllerCodigo9 = TextEditingController();
  final _controllerCodigo10 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String codigoCompleto = "";

  _recuperarBancoDeDados() async {

    final caminhoBancoDeDados = await getDatabasesPath();
    final localBancoDeDados = join(caminhoBancoDeDados, "banco.db");

    var db = await openDatabase(
        localBancoDeDados,
        version: 1,
        onCreate: (db, dbVersaoRecente){
          String sql = "CREATE TABLE codigos (id INTEGER PRIMARY KEY AUTOINCREMENT, codigo VARCHAR, userId VARCHAR, status INTEGER)";
          db.execute(sql);
        }
    );
    return db;
  }

  _salvar(BuildContext context, String codigo) async {
    //print(codigo);
    if(codigo.length == 44){
      Database db = await _recuperarBancoDeDados();
      Map<String, dynamic> dadosCodigo = {
        "codigo" : codigo,
        "userId" : "1",
        "status" : "0"
      };
      int id = await db.insert("codigos", dadosCodigo);
      if(id != null){
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      }
    }else{
      return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) =>
        AlertDialog(
          title: Text('Verifique o código!'),
          actions: [
            TextButton(
              child: const Text('Entendi'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
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
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send, color: Colors.white,),
        backgroundColor: Colors.green,
        onPressed: () async {
          _salvar(
            context,
            _controllerCodigo.text +
            _controllerCodigo1.text +
            _controllerCodigo2.text +
            _controllerCodigo3.text +
            _controllerCodigo4.text +
            _controllerCodigo5.text +
            _controllerCodigo6.text +
            _controllerCodigo7.text +
            _controllerCodigo8.text +
            _controllerCodigo9.text +
            _controllerCodigo10.text
          );
        },
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
                "Digite o código do cupom fiscal.",
              style: GoogleFonts.lato(
                fontSize: 32,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              "Os números devem estar próximos ao código de barras.",
              style: GoogleFonts.lato(
                  fontSize: 18,
              ),
            ),
            SizedBox(height: 15,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CampoFormulario(
                        _controllerCodigo,
                        TextInputAction.next
                      ),
                      CampoFormulario(
                          _controllerCodigo1,
                          TextInputAction.next
                      ),
                      CampoFormulario(
                          _controllerCodigo2,
                          TextInputAction.next
                      ),
                      CampoFormulario(
                          _controllerCodigo3,
                          TextInputAction.next
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CampoFormulario(
                          _controllerCodigo4,
                          TextInputAction.next
                      ),
                      CampoFormulario(
                          _controllerCodigo5,
                          TextInputAction.next
                      ),
                      CampoFormulario(
                          _controllerCodigo6,
                          TextInputAction.next
                      ),
                      CampoFormulario(
                          _controllerCodigo7,
                          TextInputAction.next
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CampoFormulario(
                          _controllerCodigo8,
                          TextInputAction.next
                      ),
                      CampoFormulario(
                          _controllerCodigo9,
                          TextInputAction.next
                      ),
                      CampoFormulario(
                          _controllerCodigo10,
                          TextInputAction.send
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/5.3,
                        child: Image.asset(
                          "assets/img/logo.png",
                          width: 50,
                          height: 50,
                        ),
                      )
                    ],
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
class CampoFormulario extends StatelessWidget {
  late TextEditingController textEditingController;
  late TextInputAction inputAction;
  CampoFormulario(
      this.textEditingController,
      this.inputAction,
  );

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Container(
      width: MediaQuery.of(context).size.width/5.3,
      child: TextFormField(
        onChanged: (value) {
          if (value.length == 4) node.nextFocus();
        },
        controller: textEditingController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly
        ],
        validator: (text) {
          if (text == null || text.isEmpty || text.length < 4) {
            return 'Código inválido';
          }
          return null;
        },
        textInputAction: inputAction,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
        counterText: "",
        focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 0,
        )),
        fillColor: Colors.black
        ),
        maxLength: 4,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.green,
        )
      ),
    );
  }
}
