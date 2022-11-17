import 'package:flutter/material.dart';
import 'Models/ItemPesquisa.dart';
import 'Views/Inicio/Inicio.dart';
import 'Views/Login.dart';
import 'Views/Produtos/Produto.dart';
import 'Views/Scanner/BarCode.dart';
import 'Views/Scanner/BarCodeScan.dart';
import 'Views/Scanner/BarCodeScanDois.dart';
import 'Views/Scanner/DigitarCodigo.dart';
import 'Views/Scanner/EnviaCodigo.dart';
import 'Views/Scanner/ScanNew.dart';
import 'Views/Scanner/Scanner.dart';
import 'Views/Usuario/Cadastro.dart';
import 'Views/Usuario/Configuracao.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings){

    switch( settings.name ){
      case "/" :
        return MaterialPageRoute(
            builder: (_) => const Inicio()
        );
      case "/login" :
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "/scan" :
        return MaterialPageRoute(
            builder: (_) => const Scanner()
        );
      case "/scanNew" :
        return MaterialPageRoute(
            builder: (_) => const ScanNew()
        );
      case "/barCode" :
        return MaterialPageRoute(
            builder: (_) => const BarCodeScan()
        );
      case "/barCodeSimples" :
        return MaterialPageRoute(
            builder: (_) => const BarCode()
        );
      case "/segundoCod" :
        final codigoUm = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => BarCodeScanDois(codigoUm!)
        );
      case "/configuracao" :
        return MaterialPageRoute(
            builder: (_) => const Configuracao()
        );
      case "/cadastro" :
        return MaterialPageRoute(
            builder: (_) => const Cadastro()
        );
      case "/digitarCodigo" :
        return MaterialPageRoute(
            builder: (_) => DigitarCodigo()
        );
      case "/enviaCodigo" :
        final args = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => EnviaCodigo(args)
        );
      case "/produto" :
        var produto = settings.arguments as ItemPesquisa;
        return MaterialPageRoute(
            builder: (_) => Produto(produto)
        );
      default:
        _erroRota();
    }
    return MaterialPageRoute(
        builder: (_) => const Inicio()
    );
  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
        builder: (_){
          return Scaffold(
            appBar: AppBar(
              title: const Text("Tela não encontrada!"),
            ),
            body: const Center(
              child: Text("Tela não encontrada!"),
            ),
          );
        }
    );
  }
}