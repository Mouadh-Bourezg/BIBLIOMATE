import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import './SignUpPage.dart';
import './HomePage.dart';
import './services/supabase_service.dart';

class SignInPage extends StatefulWidget {
  static const pageRoute = '/SignIn';
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false; // Loading state for sign-in button
  bool _obscurePassword = true;

  Future<void> _signIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });
      try {
        // Perform sign-in action
        final response = await Supabase.instance.client.auth.signInWithPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // Save the session
        if (response.session != null) {
          await SupabaseService.persistSession(
              response.session!.persistSessionString);
        }
        // Navigate to the main page after successful sign-in
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      } catch (e) {
        // Handle specific errors
        String errorMessage = 'An unexpected error occurred.';
        if (e.toString().contains('Invalid login credentials')) {
          errorMessage = 'Invalid email or password.';
        } else if (e.toString().contains('Network')) {
          errorMessage = 'No internet connection. Please try again.';
        }
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
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

    // Common styling
    const Color primaryColor = Color(0xFF2979FF); // Customize as needed

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
                      onTap: () =>
                          Navigator.pop(context), // Go back when tapped
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
                    'Login',
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
                    'Login to continue using the app',
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
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02, // 2% of screen height
                      horizontal: screenWidth * 0.05, // 5% of screen width
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          screenWidth * 0.2), // 2% of screen width
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
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
                // Password text field with toggle
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02, // 2% of screen height
                      horizontal: screenWidth * 0.05, // 5% of screen width
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          screenWidth * 0.2), // 2% of screen width
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: verticalPadding * 2),
                // Login button
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
                    onPressed: _isLoading ? null : () => _signIn(context),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Login',
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
                // Footer: Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // 4% of screen width
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SignUpPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                  opacity: animation, child: child);
                            },
                          ),
                        );
                        if (result != null) {
                          emailController.text = result["email"] ?? '';
                          passwordController.text = result["password"] ?? '';
                        }
                      },
                      child: Text(
                        'Register',
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
