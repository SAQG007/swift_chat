// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:swift_chat/config/globals.dart';
import 'package:swift_chat/models/message_model.dart';
import 'package:swift_chat/widgets/chat/chat_info_dialog.dart';
import 'package:swift_chat/widgets/chat/chat_members_dialog.dart';
import 'package:swift_chat/widgets/chat/no_room_found_dialog.dart';

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

  final List<MessageModel> _messages = [];
  final List<String> _chatMembers = [];
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
          _chatMembers.add(userName);
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
      
      socket.on("user-joined", (memberName) {
        _setMessage("system", "$memberName has joined the chat");

        setState(() {
          _chatMembers.add(memberName);
        });
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
        return ChatInfoDialog(
          isChatCreated: widget.isChatCreated,
          chatRoomId: _chatRoomId,
        );
      }
    );
  }

  void _showRoomNotFoundDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const NoRoomFoundDialog();
      },
    );
  }
  
  void _showChatMembersDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ChatMembersDialog(
          chatMembers: _chatMembers,
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
            onPressed: _showChatMembersDialog,
            icon: const Icon(Icons.contacts_outlined),
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
                return message.type != "system"
                // display if the message is not a system type message
                ? ChatBubble(
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
                        : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                // display if the message is a system type message
                : Chip(
                  label: Text(
                    message.message,
                  ),
                  shape: const StadiumBorder(),
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
