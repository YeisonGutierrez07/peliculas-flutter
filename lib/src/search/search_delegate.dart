import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {

  final peliculasProvider = new PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query=''
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda de nuestro AppBar
    return IconButton(
      onPressed: () => close(context, null),
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      )
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        
        if (snapshot.hasData) {
          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map((peli) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(peli.getIMGPoster()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(peli.title),
                subtitle: Text(peli.originalTitle),
                onTap: () {
                  close(context, null);
                  peli.uniqueID = '';

                  Navigator.pushNamed(context, 'detalle', arguments: peli);
                },
              );
            }).toList()
          );
        }
        return Center (child: CircularProgressIndicator());
      },
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Sugerencias que pone cuando el ususario escribe

  //   var listaSugerida = [];

  //   if (query.isEmpty) {
  //     listaSugerida = peliculasRecientes;
  //   } else {
  //     listaSugerida = peliculas.where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();
  //   }

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, i) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title:Text(listaSugerida[i])
  //       );
  //     },
  //   );
  // }

}