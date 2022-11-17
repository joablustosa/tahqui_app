import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '/Models/Usuario.dart';
import '/Models/UsuarioRetorno.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";
  bool _carregando = false;
  late UsuarioRetorno usuarioRetorno;

  _validarCampos(){

    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if( email.isNotEmpty && email.contains("@") ){
      if( senha.isNotEmpty && senha.length > 6 ){
        _logarUsuario( email, senha );
      }else{
        setState(() {
          _mensagemErro = "Preencha a senha! digite mais de 6 caracteres";
        });
      }

    }else{
      setState(() {
        _mensagemErro = "Preencha o E-mail válido";
      });
    }

  }

  _logarUsuario( String email, String senha ) async {
    final LocalStorage usuarioStorage = new LocalStorage('local');
    setState(() {
      _carregando = true;
    });
    var url = Uri.http('tahqui.herokuapp.com', '/api/User/SignIn', {'q': '{http}'});
    var header = {
      "Content-Type" : "application/json",
      "accept" : "text/plain"
    };

    Map params = {
      'email': email,
      "password": senha
    };
    var body = json.encode(params);
    var response = await http.post(
        url,
        headers: header,
        body: body
    );
    if(response.statusCode == 200 || response.statusCode == 201){
      usuarioRetorno = UsuarioRetorno.fromJson(jsonDecode(response.body));
      usuarioStorage.setItem('usuario', usuarioRetorno);
      Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
    }else{
      print(response.statusCode);
    }
  }

  // _verificarUsuarioLogado() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User usuarioLogado = await auth.currentUser;
  //   if( usuarioLogado != null ){
  //     String idUsuario = usuarioLogado.uid;
  //     Navigator.pushReplacementNamed(context, "/inicio");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    //_verificarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  "assets/img/logo.png",
                  width: 150,
                  height: 150,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: _controllerEmail,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: MaterialButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    onPressed: (){
                      _validarCampos();
                    }
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: GestureDetector(
                    child: Text(
                      "Não tem conta? cadastre-se!",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, "/cadastro");
                    },
                  ),
                ),
              ),
              _carregando
                  ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white,),)
                  : Container(),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}