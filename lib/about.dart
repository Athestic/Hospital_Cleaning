import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
            style: TextStyle(color: Colors.teal, fontFamily: 'Poppins', fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Our app prioritizes the safety of our patients, doctors, attendants, staff members, and all those who work for our organization. Health and safety are our top priorities.With our hospital floor cleaning application, we ensure that every corner of our facility is maintained to the highest standards of cleanliness. Our app schedules and monitors cleaning tasks to guarantee that every floor is sanitized regularly, creating a safe and healthy environment for everyone. This helps in minimizing the risk of infections and ensures that our hospital remains a clean and welcoming place for all.',
              textAlign: TextAlign.justify,

              style: TextStyle(fontSize: 16,fontFamily: 'Poppins', color: Colors.black),
            ),
            SizedBox(height: 100),
            Center(
              child: Column(
                children: [
                  Text(
                    'Your Health Matters',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'to Us!',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Crafted with ❤️ in Noida',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
