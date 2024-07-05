import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'package:housekeeping/admin_login.dart';
import 'package:housekeeping/about.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(color: Colors.teal, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: Colors.teal,
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/rcs.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Rcs Global Pvt. Ltd.',
                    style: TextStyle(color: Colors.white,fontFamily: 'Poppins', fontSize: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
              ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.teal),
                    title: Text('Home', style: TextStyle(color: Colors.teal)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.login, color: Colors.teal),
                    title: Text('Complaint', style: TextStyle(color: Colors.teal)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.login, color: Colors.teal),
                    title: Text('Admin ', style: TextStyle(color: Colors.teal)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminLogin()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info, color: Colors.teal),
                    title: Text('About', style: TextStyle(color: Colors.teal)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutPage()),
                      );
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '© 2024 Rcs Global Pvt. Ltd.',
                style: TextStyle(color: Colors.grey,fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
      body:  Column(
          children: <Widget>[

        Center(
          child: Image.asset(
            'assets/ramalogo.png',
            width: 200,
            height: 100,
          ),
        ),
        // Spacer(flex: 3),
      SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome to Rama Hospital',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,fontFamily: 'Poppins', color: Colors.teal),
            ),
            SizedBox(height: 10),
            Text(
              'Rama Hospital is dedicated to providing excellent healthcare services. Our mission is to ensure a clean, safe, and welcoming environment for all our patients, visitors, and staff. Together, we can maintain the highest standards of hygiene and cleanliness.',
              style: TextStyle(fontSize: 16,fontFamily: 'Poppins', color: Colors.black),
            ),
            SizedBox(height: 20),
            Text(
              'Top Performer of the Month',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,fontFamily: 'Poppins', color: Colors.teal),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Image.asset('assets/house.jpg', width:100, height: 100),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name of the Performer',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'A mini description about performer',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    '"Join Us in Keeping Rama Hospital Sparkling Clean"',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    },
                    child: Text('Join Now'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ]
      )
    );

  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
    theme: ThemeData(
      primaryColor: Colors.teal,
    ),
  ));
}
