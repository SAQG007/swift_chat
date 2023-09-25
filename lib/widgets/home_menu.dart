import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swift_chat/config/globals.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({ Key? key }) : super(key: key);

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {

  final TextEditingController _chatNameController = TextEditingController();

  void _showChatNameInputDialog(bool isCreating) {
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
