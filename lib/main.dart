import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '/RouteGenerator.dart';
import 'Views/Inicio/Inicio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      const MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('pt','BR')
        ],
        title: "Taí",
        home: Inicio(),
        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
      ));
}

