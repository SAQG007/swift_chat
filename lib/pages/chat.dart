// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:swift_chat/config/globals.dart';
import 'package:swift_chat/models/message_model.dart';
import 'package:swift_chat/pages/home.dart';

class Chat extends StatefulWidget {
  // to handle that is the chat created or joined to show info dialog accordingly
  final bool isChatCreated;
  // this will work as chat name in case of creating a chat room and a chat room id in case of joining a chat room
  final String chatJoingDetails;

  const Chat({
    Key? key,
    required this.isChatCreated,
    required this.chatJoingDetails,
  }) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  List<MessageModel> _messages = [];
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  String _chatName = "";
  String _chatRoomId = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _chatName = widget.chatJoingDetails;
    });
    _handleSocketConnection();
  }

  void _handleSocketConnection() {
    socket = IO.io("$ipAddress:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();

    if(widget.isChatCreated) {
      socket.emit("create-chat", [userName, widget.chatJoingDetails]);
    }
    else {
      setState(() {
        _chatRoomId = widget.chatJoingDetails;
      });
      socket.emit("join-chat", [userName, widget.chatJoingDetails]);
    }

    socket.onConnect((data) {
      socket.on("generated-roomId", (roomId) {
        setState(() {
          _chatRoomId = roomId;
        });
        _showInfoDialog();
      });
      
      socket.on("chat-room-name", (chatName) {
        setState(() {
          _chatRoomId = widget.chatJoingDetails;
          _chatName = chatName;
        });
      });

      socket.on("room-not-found", (data) {
        _showRoomNotFoundDialog();
      });

      socket.on("message", (msg) {
        _setMessage("destination", msg);
      });
    });
  }

  void _sendMessage() {
    socket.emit("message", [_chatRoomId, _messageController.text]);
    _setMessage("source", _messageController.text);
    _messageController.clear();
  }

  void _setMessage(String type, String message) {
    MessageModel messageModel = MessageModel(
      type: type,
      message: message,
    );

    setState(() {
      _messages.add(messageModel);
    });
  }

  void _showInfoDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.info_outline),
          title: Text(
            widget.isChatCreated
            ? "Chat Room Created"
            : "Chat Room Joined"
          ),
          content: widget.isChatCreated
          ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Welcome to the chat room! Please be aware that anyone can join using the chat room's unique ID. For your safety and privacy, avoid sharing personal information or important credentials during conversations or share the chat room's unique ID with only the people you trust. Let's keep the chat respectful and fun!"
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  const Text(
                    "Chat Unique ID: "
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: _chatRoomId));
                      Fluttertoast.showToast(
                        msg: "ID copied to clipboard",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        fontSize: 16.0,
                        backgroundColor: Theme.of(context).colorScheme.outline,
                      );
                    },
                    icon: const Icon(Icons.copy_outlined),
                    label: Text(
                      _chatRoomId
                    ),
                  ),
                ],
              ),
            ],
          )
          : const Text( 
            "Welcome to the chat room! Please note that when joining this chat room, you will not be able to view previous messages. The conversation starts fresh from this point forward.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      }
    );
  }

  void _showRoomNotFoundDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.priority_high_outlined),
          title: const Text("No room found"),
          content: const Text("Unable to find a room with the provided Room ID. Please try again with the correct ID or try creating a new chat room."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home()
                  ),
                );
              },
              child: const Text(
                "Go Back",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          _chatName,
        ),
        leading: IconButton(
          onPressed: () {
            _showInfoDialog();
          },
          icon: const Icon(Icons.info_outlined),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.view_list_outlined),
          ),
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
                  margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
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
                suffixIcon: IconButton(
                  onPressed: () {
                    if(_messageController.text.isNotEmpty) {
                      _sendMessage();
                    }
                  },
                  icon: const Icon(Icons.send_outlined),
                ),
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
