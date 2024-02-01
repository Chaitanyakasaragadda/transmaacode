import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transmaacode/drivers/check%20details.dart';

class imagepick extends StatefulWidget {
  @override
  _imagepickState createState() => _imagepickState();
}

class _imagepickState extends State<imagepick> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }
  pickImage(ImageSource source) async{
    final ImagePicker _imagePicker=ImagePicker();
    XFile?_file = await _imagePicker.pickImage(source: source);
    if(_file!=null){
      return await _file.readAsBytes();

    }
    print('No Images Selected');

  }

  Future<void> saveProfileAndNavigate() async {
    try {
      String imageUrl = await uploadImageToStorage('profileImage', _image!);
      String documentId = await saveDataToFirestore(imageUrl);
      print('Image uploaded and stored successfully! Document ID: $documentId');

      // After saving, navigate to the next page with the document ID
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => checkdetails(documentId: documentId),
        ),
      );
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    Reference ref = _storage.ref().child(childName).child('id');
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveDataToFirestore(String imageUrl) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      // Add data to Firestore and get the document ID
      DocumentReference docRef = await _firestore.collection('userProfile').add({
        'imageLink': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Return the document ID
      return docRef.id;
    } catch (error) {
      print('Error saving data to Firestore: $error');
      throw error; // Rethrow the error so that it can be caught in the calling function
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 5),
                Container(
                  color: Colors.red,
                  height: 7,
                  width: 90,
                ),
                SizedBox(width: 5),
                Container(
                  color: Colors.red,
                  height: 7,
                  width: 90,
                ),
                SizedBox(width: 5),
                Container(
                  color: Colors.red,
                  height: 7,
                  width: 90,
                ),
                SizedBox(width: 5),
                Container(
                  color: Colors.red,
                  height: 7,
                  width: 85,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text(
              'Upload pic',
              style: TextStyle(fontSize: 22),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        'https://example.com/default_image.jpg',
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
      floatingActionButton: FloatingActionButton(
        onPressed: saveProfileAndNavigate,
        tooltip: 'Save Profile and Navigate',
        child: Icon(
          Icons.arrow_forward_rounded,
          size: 55,
          color: Colors.red, // Set the icon color to red
        ),
        backgroundColor: Colors.orangeAccent, // Set the FAB background color to white
        elevation: 2, // Set elevation to give a slight shadow
        shape: CircleBorder( // Set the shape to CircleBorder
          side: BorderSide(color: Colors.red, width: 7), // Set the border color to red and width
        ),
      ),

    );
  }
}

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName).child('id');
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({
    required Uint8List file,
  }) async {
    String resp = "Some Error Occurred";
    try {
      String imageUrl = await uploadImageToStorage('profileImage', file);
      // Add data to Firestore
      await _firestore.collection('userProfile').add({
        'imageLink': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
      resp = 'success';
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}