import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Startup Name Generator'),
        ),
        body: RandomWords(),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return Divider();
        }

        final index = i ~/ 2;
        // print('i=$i index=$index');
        if (index >= _suggestions.length) {
          final tenMore = generateWordPairs().take(10);
          _suggestions.addAll(tenMore);
        }

        return _buildRow(index, _suggestions[index]);
      },
    );
  }

  Widget _buildRow(int index, WordPair pair) {
    return ListTile(
      title: Text(
        '$index. ${pair.asPascalCase}',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
