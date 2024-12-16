import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'onboardingscreen.dart';
import 'data_script.dart';
import 'signup_Screen.dart'; // Adjust the path to your actual screen

// Define the root of the application
class FashionStoreApp extends StatelessWidget {
  const FashionStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fashion Store',
      theme: ThemeData(
        primarySwatch: Colors.pink, // Set primary theme color
      ),
      home: const OnboardingScreen(), // Initial screen of the app
    );
  }
}

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(const FashionStoreApp()); // Use FashionStoreApp as the root widget
}
