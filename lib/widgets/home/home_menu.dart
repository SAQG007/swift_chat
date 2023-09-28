import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swift_chat/config/globals.dart';
import 'package:swift_chat/pages/chat.dart';
import 'package:swift_chat/widgets/home/social_media_buttons.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({ Key? key }) : super(key: key);

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {

  final TextEditingController _chatJoiningDetailsController = TextEditingController();

  // isChatCreating bool will help to show dialog on the Chat page and show the Text button accordingly
  void _showChatNameInputDialog(bool isChatCreating) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.group_add_outlined),
          title: Text(
            isChatCreating ? "Enter Room Name" : "Enter Room ID",
          ),
          content: TextFormField(
            controller: _chatJoiningDetailsController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            maxLength: isChatCreating ? 20 : 6,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              labelText: isChatCreating ? "Room Name" : "Room ID",
              prefixIcon: Icon(
                isChatCreating ? Icons.badge_outlined : Icons.pin_outlined
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _chatJoiningDetailsController.clear();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if(_chatJoiningDetailsController.text.isNotEmpty) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Chat(
                        isChatCreated: isChatCreating,
                        chatJoiningDetails: _chatJoiningDetailsController.text
                      ),
                    ),
                  );
                }
              },
              child: Text(
                isChatCreating ? "Create" : "Join",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Welcome, $userName",
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
        const SizedBox(
          height: 20.0,
        ),
        const SocialMediaButtons(),
      ],
    );
  }
}
