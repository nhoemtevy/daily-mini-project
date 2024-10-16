import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import HomeScreen

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _termsAccepted = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String? _password;
  String? _confirmPassword;
  bool _isImageVisible = true; // Variable to control image visibility
  String? _email; // Variable to store email input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1D28),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1D28),
        elevation: 0,
        title: const Text(
          'Sign Up as a New User',
          style: TextStyle(fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Handle back button action
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 5),
              // Conditionally render the image
              if (_isImageVisible)
                Image.asset(
                  'assets/images/daily.png',
                  height: 170,
                  width: 170,
                ),
              const SizedBox(height: 12),
              // Name input
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                  labelStyle: TextStyle(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email input
              TextFormField(
                style: const TextStyle(color: Colors.white), // Text color
                decoration: const InputDecoration(
                  labelText: 'Enter your email',
                  labelStyle: TextStyle(color: Colors.grey), // Label color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Border color when focused
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Border color when enabled
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Error border color
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Focused error border color
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorStyle: TextStyle(color: Colors.red), // Custom error style
                ),
                validator: (value) {
                  _email = value; // Store email input
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Regex pattern for email validation
                  final emailPattern = r'^[^@]+@[^@]+\.[^@]+';
                  final regex = RegExp(emailPattern);
                  if (!regex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null; // Return null if validation passes
                },
                maxLength: 50, // Optional: set max length for email input
                autocorrect: false, // Disable autocorrect
                enableSuggestions: false, // Disable suggestions
              ),
              const SizedBox(height: 16),

              // Phone number input
              TextFormField(
                style: const TextStyle(color: Colors.white), // Text color
                keyboardType: TextInputType.phone,
                maxLength: 15, // Optional: set max length for phone numbers
                decoration: const InputDecoration(
                  labelText: 'Enter your Phone Number',
                  labelStyle: TextStyle(color: Colors.grey), // Label color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Border color when focused
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Border color when enabled
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Error border color
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Focused error border color
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorStyle: TextStyle(color: Colors.red), // Custom error style
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (value.length < 10) { // Example check for minimum length
                    return 'Please enter a valid phone number'; // Adjust validation message
                  }
                  return null; // Return null if validation passes
                },
                autocorrect: false, // Disable autocorrect
                enableSuggestions: false, // Disable suggestions
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: !_showPassword,
                style: const TextStyle(color: Colors.white), // Text color
                maxLength: 20, // Set max length for passwords
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.grey), // Label color
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword; // Toggle password visibility
                      });
                    },
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Border color when focused
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Border color when enabled
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Error border color
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Focused error border color
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorStyle: const TextStyle(color: Colors.red), // Custom error style
                ),
                validator: (value) {
                  _password = value; // Ensure _password is defined
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) { // Check for minimum length
                    return 'Password must be at least 6 characters'; // Validation message
                  }
                  return null; // Return null if validation passes
                },
                autocorrect: false, // Disable autocorrect
                enableSuggestions: false, // Disable suggestions
              ),

              // Confirm password input
              TextFormField(
                obscureText: !_showConfirmPassword, // Toggle visibility
                style: const TextStyle(color: Colors.white), // Text color
                maxLength: 20, // Set max length for confirm passwords
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(color: Colors.grey), // Label color
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword; // Toggle password visibility
                      });
                    },
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Border color when focused
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Border color when enabled
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Error border color
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Focused error border color
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorStyle: const TextStyle(color: Colors.red), // Custom error style
                ),
                validator: (value) {
                  _confirmPassword = value; // Ensure _confirmPassword is defined
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password'; // Error message for empty input
                  } else if (_password != null && value != _password) {
                    return 'Passwords do not match'; // Check if passwords match
                  }
                  return null; // Return null if validation passes
                },
                autocorrect: false, // Disable autocorrect
                enableSuggestions: false, // Disable suggestions
              ),
              const SizedBox(height: 16),


              // Terms & Conditions checkbox
              Row(
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value!;
                      });
                    },
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle terms and conditions action
                    },
                    child: const Text(
                      'I accept terms and conditions for this app.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Sign Up button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the email input is empty, hide the image
                    if (_email == null || _email!.isEmpty) {
                      setState(() {
                        _isImageVisible = false; // Hide the image
                      });
                    } else if (_termsAccepted) {
                      // Navigate to HomeScreen if validation is successful
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to HomeScreen
                      );
                    } else {
                      // Show alert if terms not accepted
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('You must accept the terms and conditions to sign up.'),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B1D28),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
