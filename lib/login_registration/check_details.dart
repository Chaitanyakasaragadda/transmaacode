
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'driver_login.dart';
import 'driver_pending_verification.dart';

class CheckDetails extends StatefulWidget {
  final String dateOfBirth;
  final String gender;
  final String bio;
  final String experience;
  final String vehicleModel;
  final String vehicleNumber;
  final String dlNumber;
  final String panCardNumber;
  final String name;
  final String phoneNumber;
  final Uint8List? image;

  CheckDetails({
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.bio,
    required this.experience,
    required this.vehicleModel,
    required this.vehicleNumber,
    required this.dlNumber,
    required this.panCardNumber,
    required this.phoneNumber,
    required this.image, // Updated to accept Uint8List
  });

  @override
  _CheckDetailsState createState() => _CheckDetailsState();
}

class _CheckDetailsState extends State<CheckDetails> {
  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController genderController;
  late TextEditingController bioController;
  late TextEditingController experienceController;
  late TextEditingController vehicleModelController;
  late TextEditingController vehicleNumberController;
  late TextEditingController dlNumberController;
  late TextEditingController panCardNumberController;
  late TextEditingController phoneController;

  String? _imageUrl; // URL of the uploaded image

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phoneNumber);
    dobController = TextEditingController(text: widget.dateOfBirth);
    genderController = TextEditingController(text: widget.gender);
    bioController = TextEditingController(text: widget.bio);
    experienceController = TextEditingController(text: widget.experience);
    vehicleModelController = TextEditingController(text: widget.vehicleModel);
    vehicleNumberController =
        TextEditingController(text: widget.vehicleNumber);
    dlNumberController = TextEditingController(text: widget.dlNumber);
    panCardNumberController =
        TextEditingController(text: widget.panCardNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    // Display the image if available
                    if (widget.image != null)
                      Column(
                        children: [
                          Image.memory(
                            widget.image!,
                            width: 150,
                            height: 150,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    SizedBox(height: 7),
                    // Display UI for each field
                    buildTextField('Name', nameController),
                    buildTextField('Phone number', phoneController),
                    buildTextField('Gender', genderController),
                    buildTextField('Date of Birth', dobController),
                    buildTextField('DL Number', dlNumberController),
                    buildTextField('Bio', bioController),
                    buildTextField('PAN Number', panCardNumberController),
                    buildTextField('Vehicle Number', vehicleNumberController),
                    buildTextField('Vehicle Model', vehicleModelController),
                    buildTextField('Experience', experienceController),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        uploadImageAndSaveData();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>verify()),
                        );
                      },
                      child: Text(
                        'Start Your Journey',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        minimumSize: Size(double.infinity, 50),
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

  Widget buildTextField(String label, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: controller,
                enabled: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter $label',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void uploadImageAndSaveData() async {
    if (widget.image != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('images/${DateTime.now()}.jpg');
      UploadTask uploadTask = ref.putData(widget.image!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await ref.getDownloadURL();

      setState(() {
        _imageUrl = imageUrl;
      });
    }

    saveDataToFirestore();
  }

  void saveDataToFirestore() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentReference = firestore.collection('Driver').doc();

    documentReference.set({
      'name': widget.name,
      'dateOfBirth': widget.dateOfBirth,
      'gender': widget.gender,
      'bio': widget.bio,
      'experience': widget.experience,
      'vehicleModel': widget.vehicleModel,
      'vehicleNumber': widget.vehicleNumber,
      'dlNumber': widget.dlNumber,
      'panCardNumber': widget.panCardNumber,
      'image': _imageUrl, // Use the uploaded image URL
      'phone_number': widget.phoneNumber,
      'status' : 'pending'
    }).then((value) {
      print('Data saved successfully!');
    }).catchError((error) {
      print('Error: $error');
    });
  }
}

