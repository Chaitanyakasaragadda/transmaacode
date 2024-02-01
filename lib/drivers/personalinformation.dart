import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transmaacode/drivers/experienceanddata.dart';

class PersonalScreen extends StatefulWidget {
  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  String? _selectedGender;

  bool passToggle = true;

  String _nameError = '';
  String _dateofbirthError = '';
  String _bioError = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateofbirthController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

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
                  Expanded(child: buildSegment(height: 9, width: 60)),
                  SizedBox(width: 8),
                  Expanded(child: buildSegment(height: 9, width: 60)),
                ],
              ),
              SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 8),
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
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Personal Information",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(),
                            errorText: _nameError,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                        child: TextField(
                          controller: _dateofbirthController,
                          decoration: InputDecoration(
                            labelText: "Date Of Birth",
                            border: OutlineInputBorder(),
                            errorText: _dateofbirthError,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        child: DropdownButtonFormField<String>(
                          value: _selectedGender,
                          hint: Text("Select Gender"),
                          items: ["Male", "Female", "Other"].map((gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        child: TextField(
                          controller: _bioController,
                          decoration: InputDecoration(
                            labelText: "Bio",
                            border: OutlineInputBorder(),
                            errorText: _bioError,
                          ),

                          maxLines: 3,
                        ),
                      ),
                      SizedBox(height: 8),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 200,),
              Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(16),
                child: IconButton(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty &&
                        _dateofbirthController.text.isNotEmpty &&
                        _selectedGender != null &&
                        _bioController.text.isNotEmpty) {
                      // Save data to Firestore
                      try {
                        await _firestore.collection('drivers').doc(FirebaseAuth.instance.currentUser!.uid).set({
                          'name': _nameController.text,
                          'dateOfBirth': _dateofbirthController.text,
                          'gender': _selectedGender!,
                          'bio': _bioController.text,
                        });
                        // Navigate to the next screen if data is saved successfully
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ExperienceScreen()),
                        );
                      } catch (e) {
                        print('Error saving data: $e');
                        // Handle error
                      }
                    } else {
                      setState(() {
                        // Set error messages for unfilled fields
                        _nameError = _nameController.text.isEmpty ? 'Please enter your Name' : '';
                        _dateofbirthError = _dateofbirthController.text.isEmpty ? 'Please enter your Date of birth' : '';
                        _bioError = _bioController.text.isEmpty ? 'Please enter your Bio' : '';
                      });
                    }
                  },
                  icon: Icon(Icons.arrow_circle_right_outlined, size:94,color: Colors.red[400],),
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
