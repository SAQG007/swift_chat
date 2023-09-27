import 'package:flutter/material.dart';

class ChatMembersDialog extends StatefulWidget {
  final List<dynamic> chatMembers;

  const ChatMembersDialog({
    Key? key,
    required this.chatMembers,
  }) : super(key: key);

  @override
  _ChatMembersDialogState createState() => _ChatMembersDialogState();
}

class _ChatMembersDialogState extends State<ChatMembersDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.contacts_outlined),
      title: const Text("Chat Members List"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width*0.7,
        height: MediaQuery.of(context).size.height*0.5,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.chatMembers.length,
          itemBuilder: ((context, index) {
            final member = widget.chatMembers[index];
            return ListTile(
              title: Text(
                "${index + 1}. $member",
              ),
            );
          })
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Members Count: ${widget.chatMembers.length}",
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
