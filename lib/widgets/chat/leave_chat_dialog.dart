import 'package:flutter/material.dart';
import 'package:swift_chat/pages/home.dart';

class LeaveChatDialog extends StatefulWidget {
  final Function() leaveChat;

  const LeaveChatDialog({
    Key? key,
     required this.leaveChat,
  }) : super(key: key);

  @override
  _LeaveChatDialogState createState() => _LeaveChatDialogState();
}

class _LeaveChatDialogState extends State<LeaveChatDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.exit_to_app_outlined),
      title: const Text("Leave Chat Room"),
      content: const Text(
        "Are you sure that you want to leave the chat? You will not be able to see the previous messages again.",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
          ),
        ),
        TextButton(
          onPressed: () {
            widget.leaveChat();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
          },
          child: const Text(
            "Leave",
          ),
        ),
      ],
    );
  }
}
