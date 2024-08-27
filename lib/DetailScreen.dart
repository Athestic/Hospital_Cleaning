import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_config.dart';

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

  void updateRemarks() async {
    final url = '${AppConfig.apiUrl}${AppConfig.updateHousekeepingImageEndpoint}?ImageId=${widget.data['floorId']}';
    final body = jsonEncode({
      'floorId': widget.data['floorId'],
      'remarks': remarksController.text,
    });

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          errorMessage = 'Remarks updated successfully.';
          widget.data['remarks'] = remarksController.text;
        });
      } else {
        setState(() {
          errorMessage = 'Error updating remarks: ${response.statusCode}';
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
        title: Text('Detail', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
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
