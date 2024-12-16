import 'package:flutter/material.dart';
import 'dart:io'; // Required to close the app
import 'signup_screen.dart'; // Replace with your actual signup screen import

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController clController;
  late AnimationController trsController;

  @override
  void initState() {
    super.initState();

    // Animation Controller for "cl"
    clController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Animation Controller for "trs"
    trsController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Start "cl" animation first, then "trs"
    clController.forward().then((_) {
      trsController.forward().then((_) {
        // Navigate to the Signup Screen after all animations
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      });
    });
  }

  @override
  void dispose() {
    clController.dispose();
    trsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Centered Text Section
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // "cl" Text
                  AnimatedBuilder(
                    animation: clController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: clController.value,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "c",
                              style: TextStyle(
                                fontSize: 120,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              "l",
                              style: TextStyle(
                                fontSize: 120,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20), // Space between "cl" and "trs"

                  // "trs" Text
                  AnimatedBuilder(
                    animation: trsController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: trsController.value,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "t",
                              style: TextStyle(
                                fontSize: 120,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              "r",
                              style: TextStyle(
                                fontSize: 120,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            Text(
                              "s",
                              style: TextStyle(
                                fontSize: 120,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Footer Section
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to start
              children: [
                // "Close app" Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: () {
                      // Exit the application
                      exit(0);
                    },
                    child: const Text(
                      "Close app",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16), // Spacing between button and footer

                // Footer Row with CULTURES CLOTHES / 2025 / MELBOURNE
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "CULTURES CLOTHES",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "  /  ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "2025",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "  /  ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "MELBOURNE",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
