import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: isLoggedIn ?   AdminLogin():AdminDashboard(),
    );
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
          'Admin Login',
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              ),
                              onPressed: () async {
                                String userId = emailController.text;
                                String password = passwordController.text;

                                if (userId == 'admin@123' && password == 'rama@123') {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setBool('isLoggedIn', true);
                                  prefs.setString('adminName', 'Dr. Aprajita Chauhan');
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
                                style: TextStyle(color: Colors.white),
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
                      color: Colors.white
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
  String errorMessage = '';
  String adminName = '';

  @override
  void initState() {
    super.initState();
    _loadAdminName();
    _initializeDates();
  }

  void _loadAdminName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      adminName = prefs.getString('adminName') ?? 'Admin';
    });
  }

  void _initializeDates() {
    DateTime now = DateTime.now();
    setState(() {
      startDate = now;
      endDate = now;
      startDateController.text = "${now.toLocal()}".split(' ')[0];
      endDateController.text = "${now.toLocal()}".split(' ')[0];
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
            'imageId':data['imageId'],
            'floorId': data['floorId'],
            'primaryImage': data['primaryImage'],
            'secondaryImage': data['secondaryImage'],
            'description': data['description'],
            'imageStatus': data['imageStatus'],
            'remark': data['remark'],
          }).toList();
          selectedData = null;
        });
      } else {
        setState(() {
          errorMessage = 'Error fetching data: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard',  style: TextStyle(color: Colors.teal, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('isLoggedIn');
              prefs.remove('adminName');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminLogin()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text('Welcome, $adminName', style: TextStyle(fontSize: 20,fontFamily: 'Poppins', color: Colors.black)),
              SizedBox(height: 20),
              TextField(
                controller: startDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => selectStartDate(context),
              ),
              SizedBox(height: 20),
              TextField(
                controller: endDateController,
                decoration: InputDecoration(
                  labelText: 'End Date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => selectEndDate(context),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: fetchData,
                child: Text('Get Data', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              if (dataList.isNotEmpty)
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text('Data List:', style: TextStyle(fontSize: 16)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          final data = dataList[index];
                          return ListTile(
                            title: Text('Floor ID: ${data['floorId']}'),
                            subtitle: Text('Description: ${data['description']}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(data: data),
                                ),
                              );
                            },
                          );
                        },
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
}

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  DetailScreen({required this.data});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final remarksController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    remarksController.text = widget.data['remarks'] ?? '';
  }

  Uint8List _convertBase64ToImage(String base64String) {
    return base64Decode(base64String);
  }

  void updateRemarks() async {
    final imageId = widget.data['imageId'];
    final url = 'http://192.168.1.196:8081/api/Application/UpdateHousekeepingImage?ImageId=$imageId';
    final body = jsonEncode({
      'imageId': imageId,
      'remark': remarksController.text,
    });

    print('Sending PATCH request to: $url');
    print('Request body: $body');

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          errorMessage = 'Remarks updated successfully.';
          widget.data['remarks'] = remarksController.text;
          widget.data['primaryImage'] = null;
          widget.data['secondaryImage'] = null;
        });
      } else {
        setState(() {
          errorMessage = 'Error updating remarks: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold,color: Colors.teal)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Floor ID: ${widget.data['floorId']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Description: ${widget.data['description']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              widget.data['primaryImage'] != null
                  ? Image.memory(_convertBase64ToImage(widget.data['primaryImage']))
                  : Text('No primary image available'),
              SizedBox(height: 10),
              widget.data['secondaryImage'] != null
                  ? Image.memory(_convertBase64ToImage(widget.data['secondaryImage']))
                  : Text('No secondary image available'),
              SizedBox(height: 20),
              TextField(
                controller: remarksController,
                decoration: InputDecoration(
                  labelText: 'Remarks',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: updateRemarks,
                child: Text('Update Remarks', style: TextStyle(color: Colors.white)),
              ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}