import 'package:flutter/material.dart';
import 'auth_service.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _authService.verifyPhoneNumber(_phoneController.text);
              },
              child: Text('Verify Phone Number'),
            ),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: 'OTP'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _authService.signInWithOTP(
                  _verificationId!,
                  _otpController.text,
                );
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
