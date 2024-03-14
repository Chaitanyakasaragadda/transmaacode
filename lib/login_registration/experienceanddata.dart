import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'check_details.dart';

class ExperienceScreen extends StatefulWidget {
  final String? name;
  final String? dateOfBirth;
  final String? gender;
  final String? bio;
  final String phoneNumber;

  ExperienceScreen({
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.bio,
    required this.phoneNumber,
  });

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  bool passToggle = true;
  Uint8List? _image;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 220,
                        child: ImagePick(
                          onImagePicked: (Uint8List? image) {
                            setState(() {
                              _image = image;
                            });
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Experience and Data',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        child: TextField(
                          controller: _experienceController,
                          onChanged: (value) {
                            setState(() {
                              _experienceError = ''; // Clear the error message when the user starts typing
                            });
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                            LengthLimitingTextInputFormatter(2), // Limit length to 10 characters
                          ],
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
                          onChanged: (value) {
                            setState(() {
                              _vehicleModelError = ''; // Clear the error message when the user starts typing
                            });
                          },
                          inputFormatters: [AlphaNumericTextInputFormatter()],
                          decoration: InputDecoration(
                            labelText: "Vehicle Model",
                            border: OutlineInputBorder(),
                            errorText: _vehicleModelError,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        child: TextField(
                          controller: _vehicleNumberController,
                          onChanged: (value) {
                            setState(() {
                              _vehicleNumberError = ''; // Clear the error message when the user starts typing
                            });
                          },
                          inputFormatters: [AlphaNumericTextInputFormatter()],
                          decoration: InputDecoration(
                            labelText: "Vehicle Number ",
                            border: OutlineInputBorder(),
                            errorText: _vehicleNumberError,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          controller: _dlNumberController,
                          onChanged: (value) {
                            setState(() {
                              _dlNumberError = ''; // Clear the error message when the user starts typing
                            });
                          },
                          inputFormatters: [AlphaNumericTextInputFormatter()],
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
                          onChanged: (value) {
                            setState(() {
                              _panCardNumberError = ''; // Clear the error message when the user starts typing
                            });
                          },
                          inputFormatters: [AlphaNumericTextInputFormatter()],
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
              Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(16),
                child: IconButton(
                  onPressed: () {
                    if (_experienceController.text.isEmpty) {
                      setState(() {
                        _experienceError = 'Please enter years of experience';
                      });
                    } else {
                      setState(() {
                        _experienceError = '';
                      });
                    }

                    if (_vehicleModelController.text.isEmpty) {
                      setState(() {
                        _vehicleModelError = 'Please enter vehicle model';
                      });
                    } else {
                      setState(() {
                        _vehicleModelError = '';
                      });
                    }

                    if (_vehicleNumberController.text.isEmpty) {
                      setState(() {
                        _vehicleNumberError = 'Please enter vehicle number';
                      });
                    } else {
                      setState(() {
                        _vehicleNumberError = '';
                      });
                    }

                    if (_dlNumberController.text.isEmpty) {
                      setState(() {
                        _dlNumberError = 'Please enter DL number';
                      });
                    } else {
                      setState(() {
                        _dlNumberError = '';
                      });
                    }

                    if (_panCardNumberController.text.isEmpty) {
                      setState(() {
                        _panCardNumberError = 'Please enter PAN card number';
                      });
                    } else {
                      setState(() {
                        _panCardNumberError = '';
                      });
                    }

                    if (_image == null) {
// Display an error message if an image is not selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select an image'),
                        ),
                      );
                    }

                    if (_experienceError.isEmpty &&
                        _vehicleModelError.isEmpty &&
                        _vehicleNumberError.isEmpty &&
                        _dlNumberError.isEmpty &&
                        _panCardNumberError.isEmpty &&
                        _image != null) {
// Navigate to the CheckDetails screen with entered data if all fields are filled and an image is selected
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckDetails(
                            name: widget.name!,
                            phoneNumber: widget.phoneNumber,
                            dateOfBirth: widget.dateOfBirth!,
                            gender: widget.gender!,
                            bio: widget.bio!,
                            experience: _experienceController.text,
                            vehicleModel: _vehicleModelController.text,
                            vehicleNumber: _vehicleNumberController.text,
                            dlNumber: _dlNumberController.text,
                            panCardNumber: _panCardNumberController.text,
                            image: _image,
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.arrow_circle_right_outlined, size: 94, color: Colors.red),
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
class AlphaNumericTextInputFormatter extends TextInputFormatter {
  final RegExp _regExp = RegExp(r'^[A-Za-z0-9]*$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
// If the new value matches the regex pattern, allow it
    if (_regExp.hasMatch(newValue.text)) {
      return newValue;
    }
// Otherwise, return the old value (no change)
    return oldValue;
  }
}


class ImagePick extends StatefulWidget {
  final Function(Uint8List?) onImagePicked;

  ImagePick({required this.onImagePicked});

  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
      widget.onImagePicked(_image);
    }
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Images Selected');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    'Upload pic',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                      radius: 70,
                      backgroundImage: MemoryImage(_image!),
                    )
                        : CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150', // Placeholder image URL
                      ),
                    ),
                    Positioned(
                      child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(Icons.add_a_photo),
                      ),
                      bottom: -10,
                      left: 80,
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
