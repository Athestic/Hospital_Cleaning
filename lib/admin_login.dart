import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? AdminDashboard() : AdminLogin();
  }
}

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberPassword = false;
  bool _obscureText = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  void _loadRememberedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('rememberPassword') ?? false) {
      setState(() {
        emailController.text = prefs.getString('userId') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
        rememberPassword = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin ',
          style: TextStyle(color: Colors.teal, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: CurvedPainter(),
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.teal,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'User Id',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              obscureText: _obscureText,
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberPassword,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberPassword = value ?? false;
                                    });
                                  },
                                ),
                                Text('Remember password'),
                              ],
                            ),
                            if (errorMessage.isNotEmpty)
                              Text(
                                errorMessage,
                                style: TextStyle(color: Colors.red),
                              ),
                            SizedBox(height: 20),
                            ElevatedButton(

                              onPressed: () async {
                                String userId = emailController.text;
                                String password = passwordController.text;

                                if (userId == 'admin@123' && password == 'rama@123') {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setBool('isLoggedIn', true);
                                  prefs.setString('adminName', 'Dr. Aprajita Chauhan',);
                                  if (rememberPassword) {
                                    prefs.setString('userId', userId);
                                    prefs.setString('password', password);
                                  }
                                  prefs.setBool('rememberPassword', rememberPassword);

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => AdminDashboard()),
                                  );
                                } else {
                                  setState(() {
                                    errorMessage = 'Invalid username or password.';
                                  });
                                }
                              },
                              child: Text(
                                'Log In',
                                style: TextStyle(color: Colors.teal,
                                  ),

                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 80,
                child: Center(
                  child: Text(
                    '© 2024 Rcs Global Pvt. Ltd.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.teal;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height * 0.75);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  DateTime? startDate;
  DateTime? endDate;
  List<Map<String, dynamic>> dataList = [];
  Map<String, dynamic>? selectedData;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final remarksController = TextEditingController();
  String errorMessage = '';
  String adminName = '';

  @override
  void initState() {
    super.initState();
    _loadAdminName();
  }

  void _loadAdminName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      adminName = prefs.getString('adminName') ?? '';
    });
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        startDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
        endDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void fetchData() async {
    if (startDate == null || endDate == null) {
      setState(() {
        errorMessage = 'Please select both start and end dates.';
      });
      return;
    }

    final url =
        'http://192.168.1.196:8081/api/Application/GetHouseImageByDateRange?startDate=${startDate!.toIso8601String()}&endDate=${endDate!.toIso8601String()}';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as List;

        setState(() {
          dataList = jsonResponse.map((data) => {
            'floorId': data['floorId'],
            'primaryImage': data['primaryImage'],
            'secondaryImage': data['secondaryImage'],
            'description': data['description'],
          }).toList();
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
        });
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred while fetching data.';
      });
      print('Error fetching data: $e');
    }
  }

  void navigateToFullScreenImage(String imageBase64, String remarks) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(imageBase64: imageBase64, remarks: remarks),
      ),
    );
  }

  void submitRemarks() async {
    if (selectedData == null) {
      setState(() {
        errorMessage = 'Please select an image to submit remarks.';
      });
      return;
    }

    String remarks = remarksController.text;
    String floorId = selectedData!['floorId'];

    final url = 'http://192.168.1.196:8081/api/Application/SubmitRemarks';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'floorId': floorId, 'remarks': remarks}),
      );

      if (response.statusCode == 200) {
        setState(() {
          errorMessage = 'Remarks submitted successfully';
        });
      } else {
        setState(() {
          errorMessage = 'Failed to submit remarks: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred while submitting remarks.';
      });
    }
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.remove('adminName');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Welcome, $adminName'),
            SizedBox(height: 10),
            TextFormField(
              controller: startDateController,
              decoration: InputDecoration(
                labelText: 'Start Date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => selectStartDate(context),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: endDateController,
              decoration: InputDecoration(
                labelText: 'End Date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => selectEndDate(context),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Get Data'),
            ),
            SizedBox(height: 10),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final data = dataList[index];
                  return ListTile(
                    title: Text('Floor Id: ${data['floorId']}'),
                    subtitle: Text(data['description']),
                    onTap: () {
                      setState(() {
                        selectedData = data;
                      });
                      navigateToFullScreenImage(data['primaryImage'], data['description']);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            if (selectedData != null)
              Column(
                children: [
                  Text('Selected Floor Id: ${selectedData!['floorId']}'),
                  TextField(
                    controller: remarksController,
                    decoration: InputDecoration(
                      labelText: 'Remarks',
                      prefixIcon: Icon(Icons.comment),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: submitRemarks,
                    child: Text('Submit Remarks'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imageBase64;
  final String remarks;

  FullScreenImagePage({required this.imageBase64, required this.remarks});

  @override
  Widget build(BuildContext context) {
    final decodedBytes = base64Decode(imageBase64);

    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Image.memory(decodedBytes),
            ),
            SizedBox(height: 10),
            Text('Remarks: $remarks'),
          ],
        ),
      ),
    );
  }
}
