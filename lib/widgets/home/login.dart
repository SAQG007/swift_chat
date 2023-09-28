// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:swift_chat/config/functions.dart';
import 'package:swift_chat/config/globals.dart';
import 'package:swift_chat/widgets/home/social_media_buttons.dart';

class Login extends StatefulWidget {
  final Function(bool) onNameProvided;

  const Login({
    Key? key,
    required this.onNameProvided,
  }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final TextEditingController _nameController = TextEditingController();

  void _setName() {
    Timer(const Duration(seconds: 2), () async {
      setUserName(_nameController.text);
      userName = await getUserName();
      _btnController.success();
      widget.onNameProvided(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Register",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(
          height: 20.0,
        ),
        TextFormField(
          controller: _nameController,
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
        const SizedBox(
          height: 20.0,
        ),
        RoundedLoadingButton(
          controller: _btnController,
          animateOnTap: false,
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            if(_nameController.text.isNotEmpty) {
              _btnController.start();
              _setName();
            }
          },
          child: const Text(
            'Continue',
            style: TextStyle(color: Colors.white)
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
