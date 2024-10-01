import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'phone_auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDiVSLs3goLrzmndUyLa9Sjp0gs4ovHHhA",
      authDomain: "utpanna-dev.firebaseapp.com",
      projectId: "utpanna-dev",
      storageBucket: "utpanna-dev.appspot.com",
      messagingSenderId: "340480522275",
      appId: "1:340480522275:web:a5ee3291e33894978ad996"
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PhoneAuthScreen(),
    );
  }
}