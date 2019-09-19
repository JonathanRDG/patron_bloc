import 'package:flutter/material.dart';
import 'package:patron_bloc/src/bloc/provider.dart';
import 'package:patron_bloc/src/pages/home_page.dart';
import 'package:patron_bloc/src/pages/login_page.dart';
import 'package:patron_bloc/src/pages/product_page.dart';
import 'package:patron_bloc/src/pages/registro_page.dart';
import 'package:patron_bloc/src/preferencias_usuario/preferencias_usuario.dart';

void main()async{
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp() );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    print(prefs.token);
    return Provider(
      child: MaterialApp(
        title: 'dshdss',
        initialRoute: 'login',
        routes: {
          'login'    : (BuildContext context) => LoginPage(),
          'home'     : (BuildContext context) => HomePage(),
          'producto' : (BuildContext context) => ProductPage(),
          'registro' : (BuildContext context) => RegistroPage()

        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ),
    );
  }
}
