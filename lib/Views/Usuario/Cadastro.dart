import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../Models/Usuario.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  String _mensagemErro = "";
  TextEditingController _name = TextEditingController();
  TextEditingController _nickname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _documentNumber = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _birthDate = TextEditingController();
  TextEditingController _street = TextEditingController();
  TextEditingController _number = TextEditingController();
  TextEditingController _complement = TextEditingController();
  TextEditingController _neighborhood = TextEditingController();
  TextEditingController _zipCode = TextEditingController();
  TextEditingController _cityId = TextEditingController();
  TextEditingController _password = TextEditingController();
  Usuario usuario = new Usuario("","", "", "", "", "", "", "", "", "", "", "", 0, "");
  DateTime _dateTimeNiver = new DateTime.now();
  _validarCampos(){

    //Recuperar dados dos campos
    String name = _name.text;
    String nickname = _nickname.text;
    String email = _email.text;
    String documentNumber = _documentNumber.text;
    String birthDate = _birthDate.text;
    String street = _street.text;
    String number = _number.text;
    String complement = _complement.text;
    String neighborhood = _neighborhood.text;
    String phone = _phone.text;
    String zipCode = _zipCode.text;
    int cityId = 1;//_cityId.text;
    String password = _password.text;

    //validar campos
    if( name.isNotEmpty ){
      if( email.isNotEmpty && email.contains("@") ){
        if( password.isNotEmpty && password.length > 6 ){
          usuario.name = name;
          usuario.email = email;
          usuario.nickname = nickname;
          usuario.documentNumber = documentNumber;
          usuario.birthDate = birthDate.substring(6,10) + '-' + birthDate.substring(3,5) + '-' + birthDate.substring(0,2);
          usuario.street = street;
          usuario.number = number;
          usuario.complement = complement;
          usuario.neighborhood = neighborhood;
          usuario.phone = phone;
          usuario.zipCode = zipCode;
          usuario.cityId = cityId;
          usuario.password = password;
          print(usuario.toMap());
          _cadastrarUsuario( usuario );
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
    }else{
      setState(() {
        _mensagemErro = "Preencha o Nome";
      });
    }

  }

  _cadastrarUsuario( Usuario usuario ) async {
      var url = Uri.http('tahqui.herokuapp.com', '/api/User', {'q': '{http}'});
      var header = {
        "Content-Type" : "application/json",
        "accept" : "text / plain"
      };

      Map params = {
        "name" : usuario.name,
        "nickname" : usuario.nickname,
        "email" : usuario.email,
        "documentNumber" : usuario.documentNumber,
        "birthDate" : usuario.birthDate,//usuario.birthDate.substring(6,9) + '-' + usuario.birthDate.substring(3,4) + '-' + usuario.birthDate.substring(0,1),
        "street" : usuario.street,
        "number" : usuario.number,
        "complement" : usuario.complement,
        "neighborhood" : usuario.neighborhood,
        "phone" : usuario.phone,
        "zipCode" : usuario.zipCode,
        "cityId" : usuario.cityId,
        "password" : usuario.password
      };

      var body = json.encode(params);
      var response = await http.post(
          url,
          headers: header,
          body: body
      );
      //print(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        Navigator.of(context).pushReplacementNamed('/');
      }else{
        print(response.statusCode);
      }
    }
  _data(data){
    String dataFormatada = DateFormat('dd/MM/yyyy').format(data);
    return dataFormatada;
  }
  var maskPhone = new MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );
  var maskCep = new MaskTextInputFormatter(
      mask: '#####-###',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Cadastro",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: _name,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome Completo",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)
                      )
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "e-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)
                      )
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      width: MediaQuery.of(context).size.width/2.3,
                      child: TextField(
                        controller: _password,
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
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
                    Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      width: MediaQuery.of(context).size.width/2.3,
                      child: TextField(
                        controller: _password,
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
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
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _nickname,
                  keyboardType: TextInputType.text,
                  // validator: (valor){
                  //   return Validador()
                  //       .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                  //       .valido(valor);
                  // },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome de exibição",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)
                      )
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      width: MediaQuery.of(context).size.width/2.3,
                      child: TextFormField(
                        controller: _documentNumber,
                        keyboardType: TextInputType.text,
                        // validator: (valor){
                        //   return Validador()
                        //       .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                        //       .valido(valor);
                        // },
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Documento",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6)
                            )
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: (){
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year),
                              lastDate: DateTime(DateTime.now().year + 1),
                              locale: Locale('pt', 'PT')
                          ).then((date) {
                            setState(() {
                              _dateTimeNiver = date!;
                            });
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(4),
                          width: MediaQuery.of(context).size.width/2.3,
                          height: 60,
                          child: Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Text(
                                        "Data de Aniversário",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Text(
                                        _dateTimeNiver == null ? _data(new DateTime.now()) : _data(_dateTimeNiver),
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                  )
                                ],
                              )
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)
                              )
                          ),
                        )
                    ),
                    // Container(
                    //   padding: EdgeInsets.only(left: 4, right: 4),
                    //   width: MediaQuery.of(context).size.width/2.3,
                    //   child: TextFormField(
                    //     controller: _birthDate,
                    //     keyboardType: TextInputType.datetime,
                    //     // validator: (valor){
                    //     //   return Validador()
                    //     //       .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                    //     //       .valido(valor);
                    //     // },
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 17,
                    //     ),
                    //     decoration: InputDecoration(
                    //         contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    //         hintText: "Data de Nascimento",
                    //         fillColor: Colors.white,
                    //         border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(6)
                    //         )
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      width: MediaQuery.of(context).size.width/1.5,
                      child: TextFormField(
                        controller: _street,
                        keyboardType: TextInputType.text,
                        // validator: (valor){
                        //   return Validador()
                        //       .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                        //       .valido(valor);
                        // },
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Ex: Rua do Tai",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6)
                            )
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      width: MediaQuery.of(context).size.width/4,
                      child: TextFormField(
                        controller: _number,
                        keyboardType: TextInputType.number,
                        // validator: (valor){
                        //   return Validador()
                        //       .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                        //       .valido(valor);
                        // },
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Nº",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6)
                            )
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      width: MediaQuery.of(context).size.width/2.3,
                      child: TextFormField(
                        controller: _complement,
                        keyboardType: TextInputType.text,
                        // validator: (valor){
                        //   return Validador()
                        //       .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                        //       .valido(valor);
                        // },
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Complemento",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6)
                            )
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      width: MediaQuery.of(context).size.width/2.3,
                      child: TextFormField(
                        controller: _neighborhood,
                        keyboardType: TextInputType.text,
                        // validator: (valor){
                        //   return Validador()
                        //       .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                        //       .valido(valor);
                        // },
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Bairro",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6)
                            )
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      width: MediaQuery.of(context).size.width/2,
                      child: TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.number,
                        // validator: (valor){
                        //   return Validador()
                        //       .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                        //       .valido(valor);
                        // },
                        inputFormatters: [
                          maskPhone
                        ],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Telefone",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6)
                            )
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      width: MediaQuery.of(context).size.width/2.6,
                      child: TextFormField(
                        controller: _zipCode,
                        keyboardType: TextInputType.number,
                        // validator: (valor){
                        //   return Validador()
                        //       .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                        //       .valido(valor);
                        // },
                        inputFormatters: [
                          maskCep
                        ],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "CEP",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6)
                            )
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 4, right: 4),
                  width: MediaQuery.of(context).size.width/2.6,
                  child: TextFormField(
                    controller: _cityId,
                    keyboardType: TextInputType.text,
                    // validator: (valor){
                    //   return Validador()
                    //       .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                    //       .valido(valor);
                    // },
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Cidade",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: MaterialButton(
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.green,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      onPressed: (){
                        _validarCampos();
                      }
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
