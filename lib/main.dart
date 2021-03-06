import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      darkTheme: ThemeData.dark(),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: Icon(Icons.chat_bubble),
            onPressed: _pushChat,
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return Divider();
          }

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            final tenMore = generateWordPairs().take(10);
            _suggestions.addAll(tenMore);
          }

          return _buildRow(index, _suggestions[index]);
        },
      ),
    );
  }

  Widget _buildRow(int index, WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        '$index. ${pair.asPascalCase}',
        style: TextStyle(fontSize: 20),
      ),
      trailing: Icon(
        Icons.favorite,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
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

  void _pushChat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(),
      ),
    );
  }

  void _pushSaved() {
    final savedList = _saved.toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(),
          body: ListView.builder(
            itemBuilder: (context, i) {
              if (i.isOdd) {
                return Divider();
              }

              final index = i ~/ 2;
              final pair = savedList[index];
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: TextStyle(fontSize: 20),
                ),
              );
            },
            itemCount: savedList.length * 2,
          ),
        ),
      ),
    );
  }
}
