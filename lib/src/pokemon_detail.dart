import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonDetail extends StatefulWidget {
  final String name;
  final String url;
  const PokemonDetail({super.key, required this.name, required this.url});
  @override
  State<PokemonDetail> createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  Map<String, dynamic>? pokemonData;

  @override
  void initState() {
    super.initState();
    _fetchPokemonData();
  }

  Future<void> _fetchPokemonData() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        setState(() {
          pokemonData = json.decode(response.body);
        });
      } else {
        throw Exception('Error al cargar detalles del Pokemon');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: pokemonData == null
      ? const Center(child: CircularProgressIndicator())
      :Center(
        child: Column(
          children: [
            Text(
              widget.name.toUpperCase(),
              style: const TextStyle(
                fontSize: 44, fontWeight:  FontWeight.bold
              ),
            ),
            const SizedBox(height: 20),
            pokemonData!['sprites'] != null ? Image.network(pokemonData!['sprites']['front_default'],scale: .2,) : Container(),
            const SizedBox(height: 10),
            Text(
              'Altura: ${pokemonData!['height']}',
              style: const TextStyle(fontSize: 26),
            ),
            Text(
              'Peso: ${pokemonData!['weight']}',
              style: const TextStyle(fontSize: 26),
            ),
          ],
        ),
      ),
    );
  }
}
