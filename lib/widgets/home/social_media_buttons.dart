// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:swift_chat/config/globals.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaButtons extends StatefulWidget {
  const SocialMediaButtons({ Key? key }) : super(key: key);

  @override
  _SocialMediaButtonsState createState() => _SocialMediaButtonsState();
}

class _SocialMediaButtonsState extends State<SocialMediaButtons> {

  Future<void> _openMail() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
      .map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: mailAddress,
      query: encodeQueryParameters(<String, String>{
        'subject': '$appName Feedback',
      }),
    );

    if(await canLaunchUrl(emailLaunchUri)) {
      launchUrl(emailLaunchUri);
    }
    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
            'Error while opening mail.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _openSocialProfile(Uri profileLink) async {
    if(!await launchUrl(profileLink, mode: LaunchMode.externalApplication)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
            'Error while opening profile.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FlutterSocialButton(
          onTap: _openMail,
          buttonType: ButtonType.email,
          title: "Send us a feedback",
          mini: true,
        ),
        FlutterSocialButton(
          onTap: () {
            _openSocialProfile(linkedInUrl);
          },
          buttonType: ButtonType.linkedin,
          title: "Connect on LinkedIn",
          mini: true,
        ),
        FlutterSocialButton(
          onTap: () {
            _openSocialProfile(gitHubUrl);
          },
          buttonType: ButtonType.github,
          title: "Follow on GitHub",
          mini: true,
        ),
      ],
    );
  }
}
