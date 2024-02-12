import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transmaacode/drivers/register.dart';

import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  final String phoneNumber;
  const LoginScreen({Key? key, required this.phoneNumber}) : super(key: key);
  static String verify = "";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  var phoneNumber = "";

  @override
  void initState() {
    countryCodeController.text = '+91';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250),
        child: AppBar(
          backgroundColor: Color(0xffffded0),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image widget
              Image.asset(
                'asset/Finallogo.png',
                width: 200, // adjust the width as needed
                height: 100, // adjust the height as needed
              ),
              // Three Text widgets with different font sizes
              Text(
                'Welcome',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                '"Unlock Your Journey"',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Register Today',
                style: TextStyle(fontSize: 18),
              ),
              // SizedBox for additional spacing if needed
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Login',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 55,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.orange),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white38,
              ),
              child: Row(
                children: [
                  SizedBox(
                      width: 40,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          style: TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          controller: countryCodeController,
                        ),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '|',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your number',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.phone),
                      ),
                      controller: phoneNumberController,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.orange,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'OR',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Navigate to the registration screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register(phoneNumber: widget.phoneNumber,)),
                );
              },
              child: Center(
                child: Text(
                  'Register A New Account?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                _verifyPhoneNumber(
                    '${countryCodeController.text + phoneNumber}');

              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange, // Change the button color here
              ),
              child: Text('Send OTP', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyPhoneNumber(String phoneNumber) async {
    try {
      // Prepend the country code if it's not already included
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+91' + phoneNumber; // Adjust the country code as necessary
      }

      bool phoneNumberExists = await APIs.phoneNumberExistsInDriversCollection(phoneNumber);

      if (phoneNumberExists) {
        // Proceed with sending OTP
        await APIs.auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {

          },
          verificationFailed: (FirebaseAuthException e) {
            // Handle verification failed
          },
          codeSent: (String verificationId, int? resendToken) {
            LoginScreen.verify = verificationId;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OTP(phoneNumber: widget.phoneNumber,),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Handle code auto retrieval timeout
          },
          timeout: Duration(seconds: 60),

        );
        print('OTP sent to $phoneNumber');
      } else {
        // Display warning message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'This phone number is not registered. Please register first.'),
          ),
        );
      }
    } catch (e) {
      print("Error verifying phone number: $e");
      // Handle error verifying phone number
    }
  }
}
class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<bool> phoneNumberExistsInDriversCollection(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Driver')
          .where('phone_number', isEqualTo: phoneNumber)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking phone number existence in the Driver collection: $e");
      return false;
    }
  }

}