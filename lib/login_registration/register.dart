import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:transmaacode/login_registration/personalinformation.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  static String verify = "";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController countryCode = TextEditingController();
  var phone = "";
  bool _isLoading = false;
  int selectedSegment = 0;
  String errorMessage = '';
  bool isVerificationCompleted = false;
  late FocusNode _otpFocusNode;

  @override
  void initState() {
    super.initState();
    _otpFocusNode = FocusNode();
    countryCode.text = '+91';
  }

  @override
  void dispose() {
    _otpFocusNode.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250),
        child: AppBar(
          backgroundColor: Color(0xffffded0),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Finallogo.png',
                width: 200,
                height: 100,
              ),
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
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSegment = 0;
                      });
                    },
                    child: buildSegment(
                        height: 9,
                        color: selectedSegment == 0
                            ? Colors.orange
                            : Colors.grey),
                  ),
                ),
                SizedBox(width: 8), // Add a gap
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSegment = 1;
                      });
                    },
                    child: buildSegment(
                        height: 9,
                        color: selectedSegment == 1
                            ? Colors.orange
                            : Colors.grey),
                  ),
                ),
                SizedBox(width: 8), // Add a gap
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSegment = 2;
                      });
                    },
                    child: buildSegment(
                        height: 9,
                        color: selectedSegment == 2
                            ? Colors.orange
                            : Colors.grey),
                  ),
                ),
                SizedBox(width: 8), // Add a gap
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSegment = 3;
                      });
                    },
                    child: buildSegment(
                        height: 9,
                        color: selectedSegment == 3
                            ? Colors.orange
                            : Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Registration',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Container(
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
                              controller: countryCode,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '|',
                          style: TextStyle(
                              fontSize: 30, color: Colors.black),
                        ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              setState(() {
                                phone = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter your number',
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.phone),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                          ),
                          onPressed: () async {
                            if (Register.verify.isEmpty &&
                                !isVerificationCompleted) {
                              await APIs.auth.verifyPhoneNumber(
                                phoneNumber: '${countryCode.text + phone}',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) async {
                                  setState(() {
                                    isVerificationCompleted = true;
                                  });
                                },
                                verificationFailed:
                                    (FirebaseAuthException e) {},
                                codeSent: (String verificationId,
                                    int? resendToken) {
                                  Register.verify = verificationId;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'OTP has been sent to ${countryCode
                                              .text + phone}'),
                                    ),
                                  );
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                                timeout: Duration(seconds: 60),
                              );
                            }
                          },
                          child: Text(
                            'Get OTP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OTP',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              controller: _otpController,
              focusNode: _otpFocusNode,
              onChanged: (value) {
                // Additional handling if needed
              },
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                errorMessage, // Display the error message here
                style: TextStyle(color: Colors.red),
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                disabledBackgroundColor: Colors.white,
                shadowColor: Colors.grey,
              ),
              onPressed: () async {
                if (isVerificationCompleted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PersonalScreen(phoneNumber: countryCode.text + phone),
                    ),
                  );
                } else {
                  _verifyOTP(_otpController.text);
                }
              },
              child: Text(
                "Continue",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSegment({double height = 6, Color color = Colors.grey}) {
    return Container(
      height: height,
      color: color,
    );
  }

  void _verifyOTP(String enteredOTP) async {
    try {
      // Verify the OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: Register.verify,
        smsCode: enteredOTP,
      );
      await APIs.auth.signInWithCredential(credential);
      String phoneNumber = countryCode.text + phone;

      // Update phone number in Firestore
      await APIs.updatePhoneNumber(phoneNumber);

      // Send FCM notification to the verified phone number


      // Navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PersonalScreen(phoneNumber: countryCode.text + phone),
        ),
      );
    } catch (e) {
      print("Error verifying OTP: $e");
      setState(() {
        // Handle errors
        if (e is FirebaseAuthException) {
          const errorMessages = {
            'invalid-verification-code': 'Incorrect OTP. Please try again.',
            'invalid-verification-id':
            'Invalid verification ID. Please restart the process.',
          };
          errorMessage = errorMessages[e.code] ??
              'An unexpected error occurred. Please try again.';
        } else {
          errorMessage = 'An unexpected error occurred. Please try again.';
        }
      });
    }
  }
}



class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> updatePhoneNumber(String phoneNumber) async {
    try {
      DocumentSnapshot docSnapshot =
      await firestore.collection('number').doc(auth.currentUser!.uid).get();

      if (docSnapshot.exists) {
        await firestore.collection('number').doc(auth.currentUser!.uid).update({
          'phoneNumber': phoneNumber,
        });
      } else {
        await firestore.collection('number').doc(auth.currentUser!.uid).set({
          'phoneNumber': phoneNumber,
        });
      }
    } catch (e) {
      print("Error updating phone number: $e");
    }
  }
}
