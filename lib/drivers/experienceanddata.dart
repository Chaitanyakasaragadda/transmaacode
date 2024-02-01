import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transmaacode/drivers/image%20pick.dart';

class ExperienceScreen extends StatefulWidget {
  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  bool passToggle = true;

  String _experienceError = '';
  String _vehicleModelError = '';
  String _vehicleNumberError = '';
  String _dlNumberError = '';
  String _panCardNumberError = '';

  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _dlNumberController = TextEditingController();
  final TextEditingController _panCardNumberController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [

              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: buildSegment(height: 9, width: 60, color: Colors.orange)),
                  SizedBox(width: 8),
                  Expanded(child: buildSegment(height: 9, width: 60, color: Colors.orange)),
                  SizedBox(width: 8),
                  Expanded(child: buildSegment(height: 9, width: 60, color: Colors.orange)),
                  SizedBox(width: 8),
                  Expanded(child: buildSegment(height: 9, width: 60)),
                ],
              ),
              SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 15),
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text('Experience and Data',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        child: TextField(
                          controller: _experienceController,
                          decoration: InputDecoration(
                            labelText: "Year's Of Experience",
                            border: OutlineInputBorder(),
                            errorText: _experienceError,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        child: TextField(
                          controller: _vehicleModelController,
                          decoration: InputDecoration(
                            labelText: "Vechicle Model",
                            border: OutlineInputBorder(),
                            errorText: _vehicleModelError,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        child: TextField(
                          controller: _vehicleNumberController,
                          decoration: InputDecoration(
                            labelText: "Vechicle Number ",
                            border: OutlineInputBorder(),
                            errorText: _vehicleNumberError,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          controller: _dlNumberController,
                          obscureText: passToggle ? true : false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("DL Number"),
                            errorText: _dlNumberError,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        child: TextField(
                          controller: _panCardNumberController,
                          decoration: InputDecoration(
                            labelText: "Pan Card Number",
                            border: OutlineInputBorder(),
                            errorText: _panCardNumberError,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      SizedBox(height: 15),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 200),
              Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(16),
                child: IconButton(
                  onPressed: () async {
                    setState(() {
                      _experienceError = _experienceController.text.isEmpty ? 'Please enter your Experience' : '';
                      _vehicleModelError = _vehicleModelController.text.isEmpty ? 'Please enter your vehicle model' : '';
                      _vehicleNumberError = _vehicleNumberController.text.isEmpty ? 'Please enter your vehicle number' : '';
                      _dlNumberError = _dlNumberController.text.isEmpty ? 'Please enter your DL number' : '';
                      _panCardNumberError = _panCardNumberController.text.isEmpty ? 'Please enter your Pan Card number' : '';
                    });

                    if (_experienceError.isEmpty &&
                        _vehicleModelError.isEmpty &&
                        _vehicleNumberError.isEmpty &&
                        _dlNumberError.isEmpty &&
                        _panCardNumberError.isEmpty) {
                      // Save data to Firestore
                      try {
                        // Get the current user's UID
                        String uid = FirebaseAuth.instance.currentUser!.uid;

                        // Save experience data in the "drivers" collection under the user's UID
                        await _firestore.collection('drivers').doc(uid).set({

                            'yearsOfExperience': _experienceController.text,
                            'vehicleModel': _vehicleModelController.text,
                            'vehicleNumber': _vehicleNumberController.text,
                            'dlNumber': _dlNumberController.text,
                            'panCardNumber': _panCardNumberController.text,
                        }, SetOptions(merge: true)); // Use merge option to update only specified fields

                        // Clear text fields after saving
                        _experienceController.clear();
                        _vehicleModelController.clear();
                        _vehicleNumberController.clear();
                        _dlNumberController.clear();
                        _panCardNumberController.clear();

                        // Navigate to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => imagepick()),
                        );
                      } catch (e) {
                        print('Error saving data: $e');
                        // Handle error
                      }
                    }
                  },
                  icon: Icon(Icons.arrow_circle_right_outlined, size: 94,color: Colors.red,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSegment({double height = 6, double width = 80, Color color = Colors.grey}) {
    return Container(
      height: height,
      width: width,
      color: color,
    );
  }
}
