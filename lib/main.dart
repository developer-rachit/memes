import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memes :}',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Memes :}'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Album> futureAlbum;

  late String imagesUri;

  @protected
  @mustCallSuper
  void didChangeDependencies() {
    futureAlbum = fetchAlbum();
  }

  Future<Album> fetchAlbum() async {
    var jsonData =
        await http.get(Uri.parse('https://meme-api.herokuapp.com/gimme'));
    var fetchData = jsonDecode(jsonData.body);

    setState(() {
      imagesUri = fetchData['url'];
    });

    return Album.fromJSON(fetchData);

    //another method for fetching
    // final response =
    //     await http.get(Uri.parse('https://meme-api.herokuapp.com/gimme'));

    // if (response.statusCode == 200) {
    //   return Album.fromJSON(jsonDecode(response.body));
    // } else {
    //   throw Exception('Failes to load the data.');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 40),
            child: FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // return Text(snapshot.data!.title);
                  return Image.network(
                    imagesUri,
                    height: 400,
                    width: 600,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: fetchAlbum,
                tooltip: 'Share',
                child: const Text('Share'),
              ),
              FloatingActionButton(
                onPressed: fetchAlbum,
                tooltip: 'Next',
                child: const Text('Next'),
              ),
            ],
          )
        ],
      )),
    );
  }
}

class Album {
  final String title;

  const Album({required this.title});

  factory Album.fromJSON(Map<String, dynamic> json) {
    return Album(title: json['author']);
  }
}
