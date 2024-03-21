import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transmaacode/login_registration/register.dart';
import '../loads/Available_loads.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {

  static String verify = "";
  final String phoneNumber;
  final VoidCallback onLogin;

  const LoginScreen({Key? key, required this.onLogin, required  this.phoneNumber}) : super(key: key);

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
          automaticallyImplyLeading: true,
          backgroundColor: Color(0xffffded0),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image widget
              Image.asset(
                'assets/Finallogo.png',
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
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                        LengthLimitingTextInputFormatter(10), // Limit length to 10 characters
                      ],
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
                  MaterialPageRoute(builder: (context) => Register()),
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
                backgroundColor: Colors.orange, // Change the button color here
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

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Driver')
          .where('phone_number', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first;
        var status = userData['status'];

        if (status == ''
            'Pending') {
          // Display under verification message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Your number is under verification. Please wait for confirmation.'),
            ),
          );
        } else if (status == 'Verified') {
          // Proceed with sending OTP
          await APIs.auth.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            verificationCompleted: (PhoneAuthCredential credential) async {
              // Handle verification completed
            },
            verificationFailed: (FirebaseAuthException e) {
              // Handle verification failed
            },
            codeSent: (String verificationId, int? resendToken) {
              LoginScreen.verify = verificationId;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OTP(enteredName: '',),
                ),
              );
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              // Handle code auto retrieval timeout
            },
            timeout: Duration(seconds: 60),
          );
          print('OTP sent to $phoneNumber');
        } else if (status == 'Rejected') {
          // Display rejected message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Your number is rejected.'),
            ),
          );
        }
      } else {
        // Display warning message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('This phone number is not registered. Please register first.'),
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

  static Future<bool> phoneNumberExists(String phoneNumber) async {
    try {
      // Query Firestore to check if the phone number exists
      QuerySnapshot querySnapshot = await firestore
          .collection('number')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .where('status', isEqualTo: phoneNumber)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking phone number existence: $e");
      // Handle error checking phone number existence
      return false;
    }

  }

  static Future<String> getVerificationStatus(String phoneNumber) async {
    try {
      // Query Firestore to get the verification status
      DocumentSnapshot documentSnapshot = await firestore
          .collection('Driver')
          .doc(phoneNumber)
          .get();

      if (documentSnapshot.exists) {
        return documentSnapshot.get('status');
      } else {
        return 'Pending'; // Assuming pending if not found
      }
    } catch (e) {
      print("Error getting verification status: $e");
      // Handle error getting verification status
      return 'error';
    }
  }

}
