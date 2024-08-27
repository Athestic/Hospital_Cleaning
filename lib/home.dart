import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'package:housekeeping/admin_login.dart';
import 'package:housekeeping/about.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MediaQuery object to get the screen size
    final size = MediaQuery.of(context).size;
    // Example of a dynamic font size
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            color: Colors.teal,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18 * textScaleFactor, // Scaled font size
          ),
        ),
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
                        width: 80 * size.width / 360, // Responsive width
                        height: 80 * size.width / 360, // Responsive height
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Rcs Global Pvt. Ltd.',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 20 * textScaleFactor, // Scaled font size
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
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
                    leading: Icon(Icons.report_problem_rounded, color: Colors.teal),
                    title: Text('Complaint', style: TextStyle(color: Colors.teal)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.teal),
                    title: Text('Admin', style: TextStyle(color: Colors.teal)),
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
                style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/ramalogo.png',
                  width: 200 * size.width / 360, // Responsive width
                  height: 100 * size.height / 640, // Responsive height
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to Rama Hospital',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 24 * textScaleFactor, // Scaled font size
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Rama Hospital is dedicated to providing excellent healthcare services. Our mission is to ensure a clean, safe, and welcoming environment for all our patients, visitors, and staff. Together, we can maintain the highest standards of hygiene and cleanliness.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16 * textScaleFactor, // Scaled font size
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Top Performer of the Month',
                style: TextStyle(
                  fontSize: 18 * textScaleFactor, // Scaled font size
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // First Row
                      buildHousekeeperInfo(size, textScaleFactor),
                      SizedBox(height: 10),
                      // Second Row
                      buildHousekeeperInfo(size, textScaleFactor),
                      SizedBox(height: 10),
                      // Third Row
                      buildHousekeeperInfo(size, textScaleFactor),
                      SizedBox(height: 10),
                      // Fourth Row
                      buildHousekeeperInfo(size, textScaleFactor),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      '"Join Us in Keeping Rama Hospital Sparkling Clean"',
                      style: TextStyle(
                        fontSize: 18 * textScaleFactor, // Scaled font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
                        foregroundColor: Colors.teal,
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32 * size.width / 360, // Responsive padding
                          vertical: 12 * size.height / 640, // Responsive padding
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build housekeeper info rows
  Widget buildHousekeeperInfo(Size size, double textScaleFactor) {
    return Row(
      children: [
        Image.asset(
          'assets/housekeeper.jpg',
          width: 100 * size.width / 360, // Responsive width
          height: 100 * size.width / 360, // Responsive height
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pushpendra Kumar Singh',
              style: TextStyle(
                fontSize: 16 * textScaleFactor, // Scaled font size
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'He is very good at his work and \n very hardworking. He does his \n work on time',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14 * textScaleFactor, // Scaled font size
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
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
