import 'package:practica_13/src/pokemon_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});
  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practica 13'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder(
          future: _llamarUrl(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            try {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    var datos = snapshot.data![index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/commons/b/b1/Pok%C3%A9ball.png'),
                      ),
                      trailing: const Icon(Icons.arrow_right),
                      title: Text(datos['name'].toString().toUpperCase()),
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PokemonDetail(
                                    name: datos['name'], url: datos['url'])))
                      },
                    );
                  });
            } catch (e) {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<List<dynamic>> _llamarUrl() async {
    try {
      var url = "https://pokeapi.co/api/v2/pokemon?limit=30";
      final respuesta = await http.get(Uri.parse(url));
      if (respuesta.statusCode == 200) {
        final _respuestajson = json.decode(respuesta.body);
        return _respuestajson['results'];
      } else {
        throw Exception('Error al cargar datos');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
