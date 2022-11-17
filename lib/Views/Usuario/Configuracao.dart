import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sqflite/sqflite.dart';

import '../../Models/Codigo.dart';
import '../../Models/UsuarioRetorno.dart';
import '../../Services/databasehelper.dart';

class Configuracao extends StatefulWidget {
  const Configuracao({Key? key}) : super(key: key);

  @override
  _ConfiguracaoState createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {
  static final String path = "lib/src/pages/profile/profile11.dart";
  List<CodigoModel> codigos = <CodigoModel>[];
  UsuarioRetorno? usuarioRetorno;
  final LocalStorage usuarioStorage = new LocalStorage('local');

  recuperarCodigos() async {
    Database db = await SqfliteDatabaseHelper().initDb();
    String sql = "SELECT * FROM codigos";
    List codigosRecuperados = await db.rawQuery(sql);
    List<CodigoModel> codigosTemporarios = <CodigoModel>[];

    for(var item in codigosRecuperados){
      CodigoModel codigoModel = CodigoModel.fromMap(item);
      codigosTemporarios.add(codigoModel);
    }

    setState(() {
      codigos = codigosTemporarios;
    });
    codigosTemporarios = [];

    return codigos;
  }

  Future<UsuarioRetorno> buscaUsuario() async {
    final LocalStorage usuarioStorage = new LocalStorage('local');
    return usuarioRetorno = await usuarioStorage.getItem('usuario');
  }

  _excluirUsuario(int id) async {
    Database db = await SqfliteDatabaseHelper().initDb();
    await db.delete(
        "codigos",
        where: "id = ?",
        whereArgs: [id]
    );
    recuperarCodigos();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buscaUsuario();
    recuperarCodigos();
  }

  @override
  Widget build(BuildContext context) {
    var _itemHeader = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 16.0,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Configuração",
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: buscaUsuario(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView(
              children: [
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      children: [
                        //avatar
                        Ink(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage("assets/img/logo.png"), fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/cadastro");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          usuarioRetorno?.cityId != "" ? Text(
                            "Bem vindo",
                            style: TextStyle(
                                color: usuarioRetorno?.cityId != "" ? Colors.purple : Colors.red,
                                fontSize: 18
                            ),
                          ) :
                          GestureDetector(
                            onTap: (){
                              Navigator.pushReplacementNamed(context, '/cadastro');
                            },
                            child: const Text(
                              "Clique aqui e cadastre-se",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text("Nome",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.purple
                    ),
                  ),
                  subtitle: Text(usuarioRetorno?.name != null ? usuarioRetorno!.name : "",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black
                    ),
                  ),
                ),
                ListTile(
                  title: Text("E-mail",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple
                    ),
                  ),
                  subtitle: Text(usuarioRetorno?.email != null ? usuarioRetorno!.email : "",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black
                    ),
                  ),
                ),
                ListTile(
                  title: Text("Nome de Exibição",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple
                    ),
                  ),
                  subtitle: Text(usuarioRetorno?.nickname != null ? usuarioRetorno!.nickname : "",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black
                    ),
                  ),
                ),
                ListTile(
                  title: Text("Endereço",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple
                    ),
                  ),
                  subtitle: Text(
                    usuarioRetorno?.street != null ? usuarioRetorno!.street : "" + ", " +
                        usuarioRetorno!.number != 0 ? usuarioRetorno!.number : "" + " - " +
                        usuarioRetorno!.neighborhood != null ? usuarioRetorno!.neighborhood : "" + " - ",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black
                    ),
                  ),
                ),
                ListTile(
                  title: Text("CEP",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple
                    ),
                  ),
                  subtitle: Text(usuarioRetorno!.zipCode != null ? usuarioRetorno!.zipCode : "",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black
                    ),
                  ),
                ),
                ListTile(
                  title: Text("Telefone",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple
                    ),
                  ),
                  subtitle: Text(usuarioRetorno!.phone != null ? usuarioRetorno!.phone : "",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Meus Cupons",
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Divider(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 800,
                  child: ListView.builder(
                    itemCount: codigos.length,
                    itemBuilder: (context, index){

                      final item = codigos[index];

                      return ListTile(
                        title: Text(
                          item.codigo,
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        leading: Icon(item.status == 1 ? Icons.done : Icons.clear, color: item.status == 1 ? Colors.green : Colors.red,),
                        subtitle: Text("Clique para excluir da lista",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                          ),),
                        onTap: (){
                          _excluirUsuario(item.id);
                        },
                      );
                    }
                  ),
                )
              ],
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }

  Padding _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 70),
      child: Divider(
        color: Colors.black,
      ),
    );
  }
}
