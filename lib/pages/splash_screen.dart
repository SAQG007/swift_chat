// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:swift_chat/config/globals.dart';
import 'package:swift_chat/pages/home.dart';
import 'package:swift_chat/pages/no_internet_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivityStatus();
  }

  Future<void> _checkConnectivityStatus() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      Future.delayed(const Duration(seconds: 3), _navigateToHome);
    }
    else {
      _toggleIsConnected();
      Fluttertoast.showToast(
        msg: "No internet connection",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
        backgroundColor: Theme.of(context).colorScheme.outline,
      );
    }
  }

  void _toggleIsConnected() {
    setState(() {
      _isConnected = !_isConnected;
    });
  }

  void _navigateToHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isConnected
      ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: LoadingAnimationWidget.beat(
                color: Theme.of(context).colorScheme.primary,
                size: 50.0,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 32.0),
              alignment: Alignment.bottomCenter,
              child: Text(
                appName,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
        ],
      )
      : NoInternetPage(
        callBackFunction: _checkConnectivityStatus,
      ),
    );
  }
}
