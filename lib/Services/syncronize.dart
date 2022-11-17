import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/Codigo.dart';
import 'databasehelper.dart';
import 'package:http/http.dart' as http;

class SyncronizationData {

  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.mobile){
      if(await InternetConnectionChecker().hasConnection){
        return true;
      }else{
        return false;
      }
    }else if (connectivityResult == ConnectivityResult.wifi){
      if(await InternetConnectionChecker().hasConnection){
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }
  final conn = SqfliteDatabaseHelper.instance;

  Future<List<CodigoModel>> recuperaListaCodigos() async {
    _recuperarBancoDeDados();
    final dbClient = await _recuperarBancoDeDados();;
    List<CodigoModel> listaCodigo = [];
    try{
      final maps = await dbClient.query(SqfliteDatabaseHelper.contactinfoTable);
      for(var item in maps){
        listaCodigo.add(CodigoModel.fromJson(item));
      }
    } catch (e) {
      print(e);
    }
    return listaCodigo;
  }

  Future<List> recuperaListaCodigosAlterados() async {
    _recuperarBancoDeDados();
    final dbClient = await _recuperarBancoDeDados();
    List listaCodigo = [];
    try{
      final maps = await dbClient.query(
          "codigos",
          where: "status = ?",
          whereArgs: [0]);
      for(var item in maps){
        listaCodigo.add(item);
      }
    } catch (e) {
      print(e);
    }
    //print(listaCodigo);
    return listaCodigo;
  }

  Future salvarnaApi(List codigoList) async {
    for(var i = 0; i < codigoList.length; i++){
      var url = Uri.https('tahqui.herokuapp.com/', '/api/Coupon', {'q': '{https}'});
      var header = {
        "Content-Type" : "application/json",
        "accept" : "text/plain"
      };

      Map params = {
        'key': codigoList[i]['codigo']
      };
      var body = json.encode(params);
      var response = await http.post(
          url,
          headers: header,
          body: body
      );
      //print(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        _atualizarUsuario(codigoList[i]['id']);
      }else{
        print(response.statusCode);
      }
    }
  }

  _atualizarUsuario(int id) async {
    Database db = await _recuperarBancoDeDados();
    Map<String, dynamic> dadosCodigo = {
      "status" : "1"
    };

    await db.update(
        "codigos",
        dadosCodigo,
        where: "id = ?",
        whereArgs: [id]
    );
  }

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
}