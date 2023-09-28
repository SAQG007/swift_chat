// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swift_chat/config/globals.dart';
import 'package:swift_chat/widgets/home/home_menu.dart';
import 'package:swift_chat/widgets/home/login.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  late bool _showHome;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _checkForUserName();
  }

  Future<void> _checkForUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString(swiftChatUserName) ?? "";

    if(userName.isEmpty) {
      _changeShowHomeState(false);
      _toggleLoadingState();
    }
    else {
      _changeShowHomeState(true);
      _toggleLoadingState();
    }
  }

  void _changeShowHomeState(bool value) {
    setState(() {
      _showHome = value;
    });
  }

  void _toggleLoadingState() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              appName,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 5.0,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: _isLoading
                  ? const CircularProgressIndicator() // show if loading is true
                  : _showHome
                  ? const HomeMenu() // show if user name is available
                  : Login(  // show if user name is not available
                    onNameProvided: (value) {
                      _changeShowHomeState(value);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
