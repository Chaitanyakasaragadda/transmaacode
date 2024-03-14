import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'experienceanddata.dart';

class PersonalScreen extends StatefulWidget {
  final String phoneNumber;
  PersonalScreen({Key? key, required this.phoneNumber}) : super(key: key);
  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  String? _selectedGender;

  bool passToggle = true;

  String _nameError = '';
  String _dateofbirthError = '';
  String _bioError = '';
  String _genderError='';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateofbirthController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      // Format the picked date to remove the timestamp
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        _dateofbirthController.text = formattedDate;
        _dateofbirthError = ''; // Clear the error message when the user selects a date
      });
    }
  }

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
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
                          onChanged: (value) {
                            setState(() {
                              _nameError = ''; // Clear the error message when the user starts typing
                            });
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                          ],
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
                          readOnly: true,

                          // Make the text field read-only
                          decoration: InputDecoration(
                            labelText: "Date Of Birth",
                            border: OutlineInputBorder(),
                            errorText: _dateofbirthError,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context),
                            ),
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
                          onChanged: (value) {
                            setState(() {
                              _bioError = ''; // Clear the error message when the user starts typing
                            });
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                          ],
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
                    if (_nameController.text.isEmpty) {
                      setState(() {
                        _nameError = 'Please enter your name';
                      });
                    } else {
                      setState(() {
                        _nameError = '';
                      });
                    }

                    if (_dateofbirthController.text.isEmpty) {
                      setState(() {
                        _dateofbirthError = 'Please select your date of birth';
                      });
                    } else {
                      setState(() {
                        _dateofbirthError = '';
                      });
                    }

                    if (_bioController.text.isEmpty) {
                      setState(() {
                        _bioError = 'Please enter your bio';
                      });
                    } else {
                      setState(() {
                        _bioError = '';
                      });
                    }

                    if (_selectedGender == null) {
                      // Display an error message if the gender is not selected
                      setState(() {
                        _genderError = 'Please select your gender';
                      });
                    } else {
                      setState(() {
                        _genderError = '';
                      });
                    }

                    if (_nameError.isEmpty &&
                        _dateofbirthError.isEmpty &&
                        _bioError.isEmpty &&
                        _genderError.isEmpty) {
                      // Navigate to the next screen if all fields are entered
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExperienceScreen(
                            name: _nameController.text,
                            dateOfBirth: _dateofbirthController.text,
                            gender: _selectedGender,
                            bio: _bioController.text,
                            phoneNumber: widget.phoneNumber,
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.arrow_circle_right_outlined, size: 94, color: Colors.red[400]),
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
