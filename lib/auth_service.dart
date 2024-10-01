import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:js' as js;
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    if (kIsWeb) {
      // For web platform
      ConfirmationResult confirmationResult = await _auth.signInWithPhoneNumber(
        phoneNumber,
        RecaptchaVerifier(
          auth: _auth,
          onSuccess: () => print('reCAPTCHA Completed!'),
          onError: (FirebaseAuthException error) => print(error),
          onExpired: () => print('reCAPTCHA Expired!'),
          container: 'recaptcha',
          size: RecaptchaVerifierSize.compact,
          theme: RecaptchaVerifierTheme.light,
        ),
      );
      // Save the confirmationResult for later use when verifying the OTP
      print("Web: Confirmation result received: ${confirmationResult.verificationId}");
    } else {
      // For mobile platforms
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          print("Mobile: Verification ID received: $verificationId");
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  Future<void> signInWithOTP(String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await _auth.signInWithCredential(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    await _auth.signInWithCredential(credential);
    await _setSessionTimeout();
  }

  Future<void> _setSessionTimeout() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryDate = DateTime.now().add(Duration(days: 30));
    await prefs.setString('sessionExpiry', expiryDate.toIso8601String());
  }

  Future<bool> isSessionValid() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryString = prefs.getString('sessionExpiry');
    if (expiryString == null) return false;
    
    final expiry = DateTime.parse(expiryString);
    return DateTime.now().isBefore(expiry);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionExpiry');
  }
}