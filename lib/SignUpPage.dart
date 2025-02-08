import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

class SignUpPage extends StatefulWidget {
  static const pageRoute = '/SignUp';
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isLoading = false; // Loading state

  // Password validation regex
  final RegExp passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  // Sign Up logic
  Future<void> _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });
      try {
        // Check if email is valid
        if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailController.text.trim())) {
          throw Exception('Invalid email format.');
        }
        // Check if password meets requirements
        if (!passwordRegex.hasMatch(passwordController.text.trim())) {
          throw Exception(
              'Password must be at least 8 characters long and contain uppercase, lowercase, and numbers.');
        }
        // Attempt to sign up the user
        final response = await Supabase.instance.client.auth.signUp(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        if (response.user == null) {
          throw Exception('Sign-Up Failed. Please try again.');
        }
        final user = response.user;
        // Insert user details into the `users` table
        await Supabase.instance.client.from('users').insert([
          {
            'id': user?.id,
            'first_name': firstnameController.text.trim(),
            'last_name': lastnameController.text.trim(),
            'email': emailController.text.trim(),
          }
        ]);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-Up Successful')),
        );
        // Return to previous screen (possibly the Login page) with email/password
        Navigator.of(context).pop({
          "email": emailController.text,
          "password": passwordController.text,
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-Up Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic padding based on screen width
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final verticalPadding = screenHeight * 0.02; // 2% of screen height

    // Primary color (match to your brand or the login screen)
    const Color primaryColor = Color(0xFF2979FF);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: verticalPadding),
                // Back Button with Circle
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        radius: screenWidth * 0.06, // 6% of screen width
                        backgroundColor: Colors.grey[200],
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: screenWidth * 0.05, // 5% of screen width
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: verticalPadding),
                // Circle avatar / user icon
                CircleAvatar(
                  radius: screenWidth * 0.15, // 15% of screen width
                  backgroundColor: Colors.grey[200],
                  child: Image.asset(
                    'assets/digital-library.png', // Replace with your own asset
                    width: screenWidth * 0.12, // 12% of screen width
                    height: screenWidth * 0.12, // 12% of screen width
                  ),
                ),
                SizedBox(height: verticalPadding * 2),
                // Title
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08, // 8% of screen width
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
                SizedBox(height: verticalPadding / 2),
                // Subtitle
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Create your account to continue',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035, // 3.5% of screen width
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                SizedBox(height: verticalPadding * 2),
                // Email label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04, // 4% of screen width
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                SizedBox(height: verticalPadding / 2),
                // Email text field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email,
                        size: screenWidth * 0.05), // 5% of screen width
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02, // 2% of screen height
                      horizontal: screenWidth * 0.05, // 5% of screen width
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          screenWidth * 0.2), // 2% of screen width
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a valid email.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: verticalPadding),
                // First Name label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'First Name',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04, // 4% of screen width
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                SizedBox(height: verticalPadding / 2),
                // First Name text field
                TextFormField(
                  controller: firstnameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your first name',
                    prefixIcon: Icon(Icons.person,
                        size: screenWidth * 0.05), // 5% of screen width
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02, // 2% of screen height
                      horizontal: screenWidth * 0.05, // 5% of screen width
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          screenWidth * 0.2), // 2% of screen width
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your first name.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: verticalPadding),
                // Last Name label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Last Name',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04, // 4% of screen width
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                SizedBox(height: verticalPadding / 2),
                // Last Name text field
                TextFormField(
                  controller: lastnameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your last name',
                    prefixIcon: Icon(Icons.person,
                        size: screenWidth * 0.05), // 5% of screen width
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02, // 2% of screen height
                      horizontal: screenWidth * 0.05, // 5% of screen width
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          screenWidth * 0.2), // 2% of screen width
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your last name.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: verticalPadding),
                // Password label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04, // 4% of screen width
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                SizedBox(height: verticalPadding / 2),
                // Password text field
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter a secure password',
                    prefixIcon: Icon(Icons.lock,
                        size: screenWidth * 0.05), // 5% of screen width
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02, // 2% of screen height
                      horizontal: screenWidth * 0.05, // 5% of screen width
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          screenWidth * 0.2), // 2% of screen width
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a password.';
                    }
                    if (!passwordRegex.hasMatch(value)) {
                      return 'Password must be at least 8 characters long and contain uppercase, lowercase, and numbers.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: verticalPadding),
                // Confirm Password label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04, // 4% of screen width
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                SizedBox(height: verticalPadding / 2),
                // Confirm Password text field
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Re-enter your password',
                    prefixIcon: Icon(Icons.lock,
                        size: screenWidth * 0.05), // 5% of screen width
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02, // 2% of screen height
                      horizontal: screenWidth * 0.05, // 5% of screen width
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          screenWidth * 0.2), // 2% of screen width
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please confirm your password.';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: verticalPadding * 2),
                // Sign Up Button with Loading Spinner
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.08, // 8% of screen height
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            screenWidth * 0.2), // 2% of screen width
                      ),
                    ),
                    onPressed: _isLoading ? null : () => _signUp(context),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  screenWidth * 0.04, // 4% of screen width
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: verticalPadding * 2),
                // Already have an account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // 4% of screen width
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04, // 4% of screen width
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: verticalPadding * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
