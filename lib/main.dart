import 'package:flutter/material.dart';
import 'package:peliculas/src/pages/home_pages.dart';
import 'package:peliculas/src/pages/peliculas_detail.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePages(),
        'detalle': (BuildContext context) => PeliculaDetail(),
      },
    );
  }
}