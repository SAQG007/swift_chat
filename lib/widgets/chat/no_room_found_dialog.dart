import 'package:flutter/material.dart';
import 'package:swift_chat/pages/home.dart';

class NoRoomFoundDialog extends StatefulWidget {
  const NoRoomFoundDialog({ Key? key }) : super(key: key);

  @override
  _NoRoomFoundDialogState createState() => _NoRoomFoundDialogState();
}

class _NoRoomFoundDialogState extends State<NoRoomFoundDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.priority_high_outlined),
      title: const Text("No room found"),
      content: const Text(
        "Unable to find a room with the provided Room ID. Please try again with the correct ID or try creating a new chat room.",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
          },
          child: const Text(
            "Go Back",
          ),
        ),
      ],
    );
  }
}
