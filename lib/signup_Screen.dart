import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart'; // Import the LoginPage (ensure file name is correct)

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Sign Up with Email and Password
  Future<void> _signUpWithEmail() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/first.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Transparent Black Overlay
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Image.asset(
                      'assets/Rc.png',
                      width: 100, // Customize width
                      height: 100, // Customize height
                    ),
                    Text(
                      'Create\nYour account',
                      style: GoogleFonts.playfairDisplay(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 35, // Adjust size based on design
                          fontWeight: FontWeight.bold,
                          height: 1.2, // Adjust line height
                        ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 30),

                    // Email Input
                    CustomInputField(
                      controller: _emailController,
                      hintText: 'E-mail Address',
                      isPassword: false,
                    ),
                    const SizedBox(height: 19),

                    // Username Input
                    CustomInputField(
                      controller: _usernameController,
                      hintText: 'Username',
                      isPassword: false,
                    ),
                    const SizedBox(height: 19),

                    // Password Input
                    CustomInputField(
                      controller: _passwordController,
                      hintText: 'Password',
                      isPassword: true, // Tooltip enabled
                    ),
                    const SizedBox(height: 29),

                    // Sign Up Button
                    RoundedButton(
                      text: 'Sign Up',
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      onPressed: _signUpWithEmail,
                    ),
                    const SizedBox(height: 16),

                    // Sign up with Google Button
                    RoundedButton(
                      text: 'Continue with Google',
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      icon: Image.asset(
                        "assets/G l.png", // Replace with the correct path
                        height: 25.0,
                        width: 25.0,
                      ),
                      onPressed: () {
                        debugPrint('Continue  with Google');
                      },
                    ),
                    const SizedBox(height: 28),

                    // Already have an account? Login
                    Column(
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Input Field for Text Input
class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;

  const CustomInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.isPassword,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword && !_isPasswordVisible,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        suffixIcon: widget.isPassword
            ? Tooltip(
                message: _isPasswordVisible ? 'Hide Password' : 'Show Password',
                child: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              )
            : null,
      ),
    );
  }
}

// Updated Rounded Button Component
class RoundedButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final Widget? icon; // Added support for an icon

  const RoundedButton({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.icon, // Optional icon parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: GoogleFonts.lato(color: textColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
