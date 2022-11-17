import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../Models/ItemPesquisa.dart';

class Pesquisa extends StatefulWidget {
  String pesquisa;
  Pesquisa(this.pesquisa);

  @override
  _PesquisaState createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {
  final _controllerPesquisa = TextEditingController();
  FocusNode myFocusNode = new FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future<List<dynamic>> enviaPesquisa(String pesquisa) async {
    var url = Uri.https('tahqui.herokuapp.com', '/Prod/${pesquisa}', {'q': '{http}'});
    List<ItemPesquisa> itens;
    var header = {
      "Content-Type" : "application/json",
    };
    var response = await http.get(url, headers: header);
    if(response.statusCode == 200) {
      List listaResponse = jsonDecode(response.body);
      itens = <ItemPesquisa>[];
      //print(listaResponse);
      for (Map map in listaResponse) {
        ItemPesquisa m = ItemPesquisa.fromJson(map as Map<String, dynamic>);
        itens.add(m);
      }
    }else{
      throw Exception();
    }
    return itens;
  }

  Future<List<dynamic>> enviaPesquisaPagina(String pesquisa) async {
    var url = Uri.https('tahqui.herokuapp.com', '/Prod/${pesquisa}', {'q': '{http}'});
    List<ItemPesquisa> itens;
    var header = {
      "Content-Type" : "application/json",
    };
    var response = await http.get(url, headers: header);
    if(response.statusCode == 200) {
      List listaResponse = jsonDecode(response.body);
      itens = <ItemPesquisa>[];
      //print(listaResponse);
      for (Map map in listaResponse) {
        ItemPesquisa m = ItemPesquisa.fromJson(map as Map<String, dynamic>);
        itens.add(m);
      }
    }else{
      throw Exception();
    }
    return itens;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.enviaPesquisa(widget.pesquisa);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.purple,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Material(
                elevation: 5.0,
                borderRadius: const BorderRadius.all(
                    Radius.circular(30)
                ),
                child: TextFormField(
                  controller: _controllerPesquisa,
                  cursorColor: Theme.of(context).primaryColor,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                  decoration: InputDecoration(
                      suffixIcon: Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.all(
                            Radius.circular(30)
                        ),
                        child: GestureDetector(
                            onTap: (){
                              enviaPesquisaPagina(_controllerPesquisa.text);
                              //Navigator.pushNamed(context, "/pesquisa", arguments: _controllerPesquisa.text);
                            },
                            child: Icon(Icons.search)
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 13
                      )
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width/1,
            height: MediaQuery.of(context).size.height/1,
            child: FutureBuilder(
              future: enviaPesquisaPagina("bloco"),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(
                        title: Text(snapshot.data[index].value != null ? snapshot.data[index].value.toString() : "Não reconhecido",
                          style: TextStyle(
                              color: Colors.black
                          ),
                        ),
                        subtitle: Text(snapshot.data[index].date != null ? snapshot.data[index].date.toString() : "Não reconhecido"),
                        trailing: Container(
                          width: 70,
                          height: 25 ,
                          child: Row(
                            children: [
                              Icon(Icons.monetization_on_outlined, color: Colors.green,),
                              Text("20,00",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16
                                  )
                              )
                            ],
                          ),
                        ),
                        onTap: (){
                          Navigator.pushNamed(
                              context, "/produto"
                          );
                        },
                      );
                    },
                  );
                }else if(snapshot.hasData == false){
                  return new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    ],
                  );
                }
                return new Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class Pesquisa extends StatefulWidget {
//   const Pesquisa({Key? key}) : super(key: key);
//
//   @override
//   _PesquisaState createState() => _PesquisaState();
// }
//
// class _PesquisaState extends State<Pesquisa> {
//   List<Map<String, dynamic>> _foundUsers = [];
//
//   final List<Map<String, dynamic>> _allUsers = [
//     {"id": 1, "name": "Batata", "age": 29},
//     {"id": 2, "name": "Morango", "age": 40},
//     {"id": 3, "name": "Bucha", "age": 5},
//     {"id": 4, "name": "Biscoito", "age": 35},
//     {"id": 5, "name": "Banana", "age": 21},
//     {"id": 6, "name": "Mesa", "age": 55},
//     {"id": 7, "name": "Maquina", "age": 30},
//     {"id": 8, "name": "Wisck", "age": 14},
//     {"id": 9, "name": "Mouse", "age": 100},
//     {"id": 10, "name": "Televisão", "age": 32},
//   ];
//
//   void _runFilter(String enteredKeyword) {
//     List<Map<String, dynamic>> results = [];
//     if (enteredKeyword.isEmpty) {
//       // if the search field is empty or only contains white-space, we'll display all users
//       results = _allUsers;
//     } else {
//       results = _allUsers
//           .where((user) =>
//           user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
//           .toList();
//       // we use the toLowerCase() method to make it case-insensitive
//     }
//
//     // Refresh the UI
//     setState(() {
//       _foundUsers = results;
//     });
//   }
//
//   @override
//   void initState() {
//     _foundUsers = _allUsers;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.purple, //change your color here
//         ),
//         title: Text(
//             "Pesquisa de produtos",
//           style: TextStyle(
//             color: Colors.purple
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Container(
//         padding: EdgeInsets.only(
//           left: 16,
//           right: 16
//         ),
//         child: Column(
//           children: [
//             TextField(
//               onChanged: (value) => _runFilter(value),
//               decoration: const InputDecoration(
//                   labelText: 'Pesquisa', suffixIcon: Icon(Icons.search)),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Expanded(
//               child: _foundUsers.isNotEmpty
//                   ? ListView.builder(
//                   itemCount: _foundUsers.length,
//                   itemBuilder: (context, index) => Card(
//                     key: ValueKey(_foundUsers[index]["id"]),
//                     color: Colors.white,
//                     elevation: 1,
//                     margin: const EdgeInsets.symmetric(vertical: 5),
//                     child: ListTile(
//                       leading: Text(
//                         _foundUsers[index]["id"].toString(),
//                         style: const TextStyle(fontSize: 24),
//                       ),
//                       title: Text(_foundUsers[index]['name']),
//                       subtitle: Text(
//                           '${_foundUsers[index]["age"].toString()} Reais'
//                       ),
//                       onTap: (){
//
//                       },
//                     ),
//                   ),
//                 )
//                   : const Text(
//                 'Nenhum Produto encontrado',
//                 style: TextStyle(fontSize: 24),
//               ),
//             ),
//           ],
//         )
//       ),
//     );
//   }
// }
