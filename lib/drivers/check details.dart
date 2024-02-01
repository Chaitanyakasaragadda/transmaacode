import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class checkdetails extends StatefulWidget {
  final String documentId;

  checkdetails({required this.documentId});

  @override
  _checkdetailsState createState() => _checkdetailsState();
}

class _checkdetailsState extends State<checkdetails> {
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    // Fetch data from Firestore when the widget is created
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      // Use the document ID passed from the previous page
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(widget.documentId)
          .get();

      // Get the image link from the fetched data
      setState(() {
        imageUrl = documentSnapshot['imageLink'];
      });
    } catch (error) {
      print('Error fetching data from Firestore: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              SizedBox(height: 10), // Add space between text and image
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12.0),
                        image: imageUrl.isNotEmpty
                            ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                            : DecorationImage(
                          image:
                          AssetImage('assets/placeholder_image.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                    // Add space between image and text fields
                    // Text field for phone number
                    buildTextField('Phone Number'),
                    SizedBox(height: 7),
                    // Text field for mail id
                    buildTextField('DL number'),
                    SizedBox(height: 7),
                    // Text field for date of birth
                    buildTextField('Date of Birth'),
                    SizedBox(height: 7),
                    // Text field for gender
                    buildTextField('Gender'),
                    SizedBox(height: 125),
                    // Add space between gender and ElevatedButton
                    // Elevated button
                    ElevatedButton(
                      onPressed: () {
                        // Add functionality for the button here
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

  Widget buildTextField(String label) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.black, // Set text color to black
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 40,
              // Adjusted height of the text field
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              // Set padding to decrease width
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white, // Set background color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    // Set focused border color to red
                    borderRadius: BorderRadius.circular(
                        5.0), // Optional: Set border radius
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    // Set enabled border color to red
                    borderRadius: BorderRadius.circular(
                        5.0), // Optional: Set border radius
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}