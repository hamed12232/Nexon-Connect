import 'package:flutter/material.dart';

class ChatInputBar extends StatefulWidget {
  final Function(String) onSendMessage;
  final VoidCallback onStartRecording;

  const ChatInputBar({
    Key? key,
    required this.onSendMessage,
    required this.onStartRecording,
  }) : super(key: key);

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _textController = TextEditingController();
  final ValueNotifier<bool> _isRecording = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _textController.dispose();
    _isRecording.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.attach_file,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {},
        ),
        Flexible(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              controller: _textController,
              onChanged: (value) {
                _isRecording.value = value.trim().isEmpty;
              },
              style: TextStyle(fontSize: 15.0),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: "Write your message...",
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
              ),
              maxLines: null,
            ),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isRecording,
          builder: (context, isRecording, child) {
            return Flexible(
              flex: 1,
              child: IconButton(
                icon: Container(
                  height: isRecording ? 50 : 60,
                  width: isRecording ? 50 : 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isRecording ? Icons.mic : Icons.send,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (isRecording) {
                    widget.onStartRecording();
                  } else {
                    if (_textController.text.trim().isNotEmpty) {
                      widget.onSendMessage(_textController.text.trim());
                      _textController.clear();
                    }
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
