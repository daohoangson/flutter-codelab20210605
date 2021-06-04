import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _focusNode = FocusNode();
  final _messages = <Widget>[];
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatScreen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => _messages[index],
              itemCount: _messages.length,
              padding: EdgeInsets.all(8),
              reverse: true,
            ),
          ),
          Container(
            child: _buildTextComposer(),
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Send a message',
              ),
              focusNode: _focusNode,
              onSubmitted: _handleSubmitted,
            ),
          ),
          IconTheme(
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
            data: IconThemeData(color: Theme.of(context).accentColor),
          )
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    final message = ChatMessage(name: 'son.dao', text: text);
    setState(() => _messages.insert(0, message));

    _focusNode.requestFocus();
  }
}

class ChatMessage extends StatelessWidget {
  final String name;
  final String text;

  const ChatMessage({Key? key, required this.name, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(text),
      leading: CircleAvatar(child: Text(name[0])),
    );
  }
}
