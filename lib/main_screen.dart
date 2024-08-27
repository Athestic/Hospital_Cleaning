import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'app_config.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<File> _images = [];
  final picker = ImagePicker();
  String _selectedFloor = '';
  String _selectedGda = '';
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSubmitting = false;
  List<Map<String, dynamic>> _floors = [];

  @override
  void initState() {
    super.initState();
    _fetchFloors();
  }

  Future<void> _fetchFloors() async {
    var uri = Uri.parse('${AppConfig.apiUrl}${AppConfig.houseKeepingEndpoint}');
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _floors = List<Map<String, dynamic>>.from(data);
        if (_floors.isNotEmpty) {
          _selectedFloor = _floors[0]['location'];
          _selectedGda = _floors[0]['gda'];
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch floor data'),
      ));
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Map<String, dynamic> buildPayload() {
    var selectedFloorData = _floors.firstWhere(
          (floor) => floor['location'] == _selectedFloor,
      orElse: () => {},
    );

    if (selectedFloorData.isEmpty) {
      return {
        'floorId': null,
        'description': _descriptionController.text,
        'gda': _selectedGda,
        'images': _images.map((image) => image.path).toList(),
      };
    }

    return {
      'floorId': selectedFloorData['floor_id'].toString(),
      'description': _descriptionController.text,
      'gda': _selectedGda,
      'images': _images.map((image) => image.path).toList(),
    };
  }

  Future<void> _submitData() async {
    if (_images.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please add at least one image and a description'),
      ));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    var payload = buildPayload();

    print('Payload: $payload');

    var uri = Uri.parse('${AppConfig.apiUrl}${AppConfig.insertHouseImageEndpoint}');
    var request = http.MultipartRequest('POST', uri);

    request.fields['floorId'] = payload['floorId'];
    request.fields['description'] = payload['description'];
    request.fields['gda'] = payload['gda'];

    for (int i = 0; i < _images.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
        i == 0 ? 'primaryImage' : 'secondaryImage${i}',
        _images[i].path,
      ));
    }

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Data submitted successfully'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        setState(() {
          _images.clear();
          _descriptionController.clear();
          _selectedFloor = _floors.isNotEmpty ? _floors[0]['location'] : '';
          _selectedGda = _floors.isNotEmpty ? _floors[0]['gda'] : '';
          _isSubmitting = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to submit data: ${response.statusCode} - $responseData'),
        ));
        setState(() {
          _isSubmitting = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
      ));
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sanitation for Safety', style: TextStyle(color: Colors.teal, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(double.infinity, double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Select Floor', style: TextStyle(fontSize: 18, color: Colors.black45, fontFamily: 'Poppins')),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: DropdownButton<String>(
                      value: _selectedFloor,
                      borderRadius: BorderRadius.circular(15),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedFloor = newValue!;
                          _selectedGda = _floors.firstWhere((floor) => floor['location'] == newValue)['gda'];
                        });
                      },
                      items: _floors.map<DropdownMenuItem<String>>((floor) {
                        return DropdownMenuItem<String>(
                          value: floor['location'],
                          child: Text('${floor['location']} (${floor['gda']})'),
                        );
                      }).toList(),
                      isExpanded: true,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      dropdownColor: Colors.teal,
                      iconEnabledColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Add Images', style: TextStyle(fontSize: 18, color: Colors.black45, fontFamily: 'Poppins')),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.teal, size: 40,),
                            onPressed: _isSubmitting ? null : _pickImage,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text('Add more images', style: TextStyle(color: Colors.teal, fontFamily: 'Poppins')),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: _images.asMap().entries.map((entry) {
                        int index = entry.key;
                        File image = entry.value;
                        return Stack(
                          children: [
                            Image.file(image, width: 100, height: 100, fit: BoxFit.cover),
                            Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Icon(Icons.remove_circle, color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Description', style: TextStyle(fontSize: 18, color: Colors.black45, fontFamily: 'Poppins')),
                  SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        labelStyle: TextStyle(color: Colors.teal),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.teal),
                        )
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitData,
                      child: _isSubmitting
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                          : Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
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
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MainScreen(),
    theme: ThemeData(
      primaryColor: Colors.teal,
    ),
  ));
}
