import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:swift_chat/models/message_model.dart';

class Chat extends StatefulWidget {
  final bool isChatCreated; // to handle that is the chat created or joined to show info dialog accordingly
  final String chatName;

  const Chat({
    Key? key,
    required this.isChatCreated,
    required this.chatName,
  }) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  List<MessageModel> _messages = [];
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.chatName
        ),
        actions: [
          IconButton(
            onPressed: () {
              // show confirmation dialog
              // exit
            },
            icon: const Icon(Icons.exit_to_app_outlined)
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  clipper: message.type == "source"
                  ? ChatBubbleClipper4(type: BubbleType.sendBubble)
                  : ChatBubbleClipper4(type: BubbleType.receiverBubble),
                  alignment: message.type == "source"
                  ? Alignment.topRight
                  : Alignment.topLeft,
                  margin: const EdgeInsets.all(10.0),
                  backGroundColor: message.type == "source"
                  ? Colors.blue
                  : const Color(0xffE7E7ED),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Text(
                      message.message,
                      style: TextStyle(
                        color: message.type == "source"
                        ? Colors.white
                        : Colors.black
                      ),
                    ),
                  ),
                );
              },
            )
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _messageController,
              focusNode: _messageFocusNode,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0)
                ),
                hintText: "Send Message",
                prefixIcon: const Icon(Icons.keyboard_outlined),
                suffixIcon: const Icon(Icons.send_outlined),
              ),
              onTapOutside: (event) {
                _messageFocusNode.unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }
}
