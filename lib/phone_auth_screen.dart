import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  bool _isLoading = false;

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
              onPressed: _isLoading ? null : _verifyPhoneNumber,
              child: _isLoading ? CircularProgressIndicator() : Text('Verify Phone Number'),
            ),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: 'OTP'),
            ),
            ElevatedButton(
              onPressed: _verificationId == null ? null : _signInWithOTP,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.verifyPhoneNumber(_phoneController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification code sent')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithOTP() async {
    try {
      await _authService.signInWithOTP(_verificationId!, _otpController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully signed in')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}