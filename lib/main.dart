// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp()); // one line method => (like a lambda function)

// extends StatelessWidget, which makes the app itself a widget
// in Flutter, almost everything is a widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.amber,
      ),
      home: RandomWords(),
    );
  }
}

// a pair of StatefulWidget and State classes
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}
// state usually private
// dart grammar: leading underscore enforce privacy
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; // a list of suggestions
  final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0); // a constant TextStyle

  // The main window
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) {

            // tiles
            final tiles = _saved.map(
                  (WordPair pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
            );

            // tiles -> divided tiles
            final divided = ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList();

            // return a new screen: saved suggestions
            return Scaffold(
              appBar: AppBar(
                title: Text('Saved Suggestions'),
              ),
              // the body consists of a listview containing the ListTiles rows
              body: ListView(children: divided),
            );
          }
      )
    );
  }

  // build list view of word pairs
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        // itemBuilder:
        // a callback called once per suggested word pairing
        // and places each suggestion into a ListTile row
        itemBuilder: (context, i) {
          // add a one-pixel-high divider widget before each row
          if (i.isOdd) return Divider();
          // divide i by 2 and return a integer result,
          // which calculates the actual number of word pairings in the ListView
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            // if reached the end of the available word pairings
            // generate 10 more and add them to _suggestions
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  // build a single row
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text( // Component 1: title
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon( // Component 2: trailing heart
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.lightBlue : null,
      ),
      onTap: () { // Component 3: on tap, change trailing heart color
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
