import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FinanceAndInsurance extends StatefulWidget {
  final String documentId;

  FinanceAndInsurance({required this.documentId});

  @override
  _FinanceAndInsuranceState createState() => _FinanceAndInsuranceState();
}

class _FinanceAndInsuranceState extends State<FinanceAndInsurance> {
  String selectedButton = 'insurance'; // Default to insurance
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController rcNumberController = TextEditingController();
  bool showFields = true; // Show insurance fields by default

  Future<void> submitData() async {
    if (nameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        vehicleTypeController.text.isNotEmpty &&
        rcNumberController.text.isNotEmpty) {
      try {
        String collectionName =
        selectedButton == 'finance' ? 'Finance' : 'Insurance';

        await FirebaseFirestore.instance.collection(collectionName).add({
          'name': nameController.text,
          'phoneNumber': phoneNumberController.text,
          'vehicleType': vehicleTypeController.text,
          'rcNumber': rcNumberController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data submitted successfully!'),
          ),
        );

        nameController.clear();
        phoneNumberController.clear();
        vehicleTypeController.clear();
        rcNumberController.clear();
      } catch (error) {
        print('Error submitting data to Firestore: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit data. Please try again later.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter all fields.'),
        ),
      );
    }
  }

  void showFieldsWithDelay(String selected) async {
    setState(() {
      showFields = false;
    });
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      selectedButton = selected;
      showFields = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  Text(
                    'Commercial Vehicles',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    width: 250,
                    child: Divider(
                      thickness: 2,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      showFieldsWithDelay('finance');
                    },
                    child: Text(
                      'Finance',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: selectedButton == 'finance'
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 180,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      showFieldsWithDelay('insurance');
                    },
                    child: Text(
                      'Insurance',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: selectedButton == 'insurance'
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (showFields)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTextField('Name', nameController),
                      SizedBox(height: 7),
                      buildTextField('Phone Number', phoneNumberController),
                      SizedBox(height: 7),
                      buildTextField('Type of Vehicle', vehicleTypeController),
                      SizedBox(height: 7),
                      buildTextField('RC Number', rcNumberController),
                      SizedBox(height: 25),
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: submitData,
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              label,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: controller,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 8, horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
