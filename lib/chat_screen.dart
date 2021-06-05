import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _focusNode = FocusNode();
  final _messages = <ChatMessage>[];
  final _textController = TextEditingController();

  var _isComposing = false;

  @override
  void dispose() {
    for (final message in _messages) {
      message.animationController.dispose();
    }

    _focusNode.dispose();
    _textController.dispose();

    super.dispose();
  }

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
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: _isComposing ? _handleSubmitted : null,
            ),
          ),
          IconTheme(
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text)
                  : null,
            ),
            data: IconThemeData(color: Theme.of(context).accentColor),
          )
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    final animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    final message = ChatMessage(
      animationController: animationController,
      name: 'son.dao',
      text: text,
    );

    setState(() {
      _messages.insert(0, message);
      _isComposing = false;
    });

    _focusNode.requestFocus();
    animationController.forward();
  }
}

class ChatMessage extends StatelessWidget {
  final AnimationController animationController;
  final String name;
  final String text;

  const ChatMessage({
    required this.animationController,
    Key? key,
    required this.name,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SizeTransition(
        child: ListTile(
          title: Text(name),
          subtitle: Text(text),
          leading: CircleAvatar(child: Text(name[0])),
        ),
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      ),
      opacity: animationController,
    );
  }
}
