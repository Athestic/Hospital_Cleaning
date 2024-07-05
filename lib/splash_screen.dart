import 'package:flutter/material.dart';
import 'package:housekeeping/home.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        children: <Widget>[
          Spacer(flex: 4),
          Center(
            child: Image.asset(
              'assets/cleaner.png',
              width: 400,
              height: 500,
            ),
          ),
          Spacer(flex: 3), // Pushes the text to the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Rcs Global Pvt. Ltd.',
              style: TextStyle(color: Colors.white, fontSize: 24, fontStyle: FontStyle.italic
              ),
            ),
          ),
        ],
      ),
    );
  }
}
