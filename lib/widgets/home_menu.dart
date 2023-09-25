import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swift_chat/config/globals.dart';
import 'package:swift_chat/pages/chat.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({ Key? key }) : super(key: key);

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {

  final TextEditingController _chatNameController = TextEditingController();

  // isChatCreating bool will help to show dialog on the Chat page and show the Text button accordingly
  void _showChatNameInputDialog(bool isChatCreating) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.group_add_outlined),
          title: const Text("Enter Room Name"),
          content: TextFormField(
            controller: _chatNameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            maxLength: 20,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              labelText: "Name",
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if(_chatNameController.text.isNotEmpty) {
                  Navigator.pop(context);
                  _showInfoDialog(isChatCreating);
                }
              },
              child: Text(
                isChatCreating
                ? "Create"
                : "Join"
              ),
            ),
          ],
        );
      },
    );
  }

  void _showInfoDialog(bool isChatCreating) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.info_outline),
          title: Text(
            isChatCreating
            ? "Chat Room Created"
            : "Chat Room Joined"
          ),
          content: Text(
            isChatCreating
            ? "Welcome to the chat room! Please be aware that anyone can join using the chat name. For your safety and privacy, avoid sharing personal information or important credentials during conversations. Let's keep the chat respectful and fun!"
            : "Welcome to the chat room! Please note that when joining this chat room, you will not be able to view previous messages. The conversation starts fresh from this point forward."
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chat(
                      isChatCreated: isChatCreating,
                      chatName: _chatNameController.text,
                    ),
                  ),
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Hello, $userName",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(
          height: 20.0,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {
              _showChatNameInputDialog(true);
            },
            child: const Text("Create a Chat Room"),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {
              _showChatNameInputDialog(false);
            },
            child: const Text("Join a Chat Room"),
          ),
        ),
      ],
    );
  }
}
