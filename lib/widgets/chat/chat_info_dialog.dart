import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatInfoDialog extends StatefulWidget {
  final bool isChatCreated;
  final String chatRoomId;

  const ChatInfoDialog({
    Key? key,
    required this.isChatCreated,
    required this.chatRoomId,
  }) : super(key: key);

  @override
  _ChatInfoDialogState createState() => _ChatInfoDialogState();
}

class _ChatInfoDialogState extends State<ChatInfoDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.info_outline),
      title: Text(
        widget.isChatCreated
        ? "Chat Room Created"
        : "Chat Room Joined",
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
                  await Clipboard.setData(ClipboardData(text: widget.chatRoomId));
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
                  widget.chatRoomId,
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
}
