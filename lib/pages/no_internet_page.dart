import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoInternetPage extends StatefulWidget {
  final VoidCallback callBackFunction;

  const NoInternetPage({
    Key? key,
    required this.callBackFunction,
  }) : super(key: key);

  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/images/illustrations/no-internet.svg',
                width: 350.0,
                height: 350.0,
              ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                  onPressed: widget.callBackFunction,
                  label: const Text("Retry"),
                  icon: const Icon(Icons.refresh_outlined),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
