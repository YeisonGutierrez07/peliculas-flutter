import 'package:flutter/material.dart';
import 'package:peliculas/src/models/modelo_autores.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetail extends StatelessWidget {

  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10.0,),
              _posterTitle(context, pelicula),
              _description(pelicula),
              _description(pelicula),
              _description(pelicula),
              _description(pelicula),
              _description(pelicula),
              _description(pelicula),
              _actoresList(context, pelicula)
            ]))
        ],
      )
    );
  }

  _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getIMGBackground()),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
          placeholder: AssetImage('assets/img/loading.gif'),
        ),
      ),
    );
  }

  _posterTitle(BuildContext context,  Pelicula pelicula) {
    return Container(
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueID,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(pelicula.getIMGPoster()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text( pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subhead)
                  ],
                )
              ],
            )
          )
        ]
      ),
    );
  }

  _description(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      )
    );
  }

  _actoresList(BuildContext context, Pelicula pelicula) {
    return FutureBuilder(
      future: peliculasProvider.getActorsByMovie(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _listaActores(snapshot.data);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _listaActores(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) {
          return _cardActor(actores[i]);
        },
      )
    );
  }

  _cardActor(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getIMGActor()),
              placeholder: AssetImage("assets/img/no-image.jpg"),
              height: 150.0,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ) 
    );
  }
}