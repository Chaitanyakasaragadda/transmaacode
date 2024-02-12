import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:transmaacode/driver%20screen/loads/Available_loads.dart';
import 'driver_login.dart';


class OTP extends StatefulWidget {
  final String phoneNumber;

  const OTP({Key? key, required this.phoneNumber,}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final TextEditingController _otpController = TextEditingController();
  String errorMessage = '';

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
              Image.asset('asset/Finallogo.png', width: 200, height: 100,),
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
            Center(
              child: Text(
                'Login',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "We've sent an SMS with an activation code to your phone",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text(
              ' ${widget.phoneNumber}',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 50,
            ),
            Pinput(
              length: 6,
              showCursor: true,
              defaultPinTheme: defaultPinTheme,
              controller: _otpController,
              onChanged: (value) {
                // Check if entered OTP is correct
                if (value.length == 6) {
                  // Clear the error message if OTP is correct
                  setState(() {
                    errorMessage = '';
                  });
                }
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Verify OTP when the button is pressed
                _verifyOTP(_otpController.text);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange, // Change the button color here
              ),
              child: Text('Verify',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            SizedBox(
              height: 18,
            ),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyOTP(String enteredOTP) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: LoginScreen.verify,
        smsCode: enteredOTP,
      );

      await APIs.auth.signInWithCredential(credential);

      // Navigate to the next screen on successful verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoadsScreen(),
        ),
      );
    } catch (e) {
      print("Error verifying OTP: $e");

      setState(() {
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