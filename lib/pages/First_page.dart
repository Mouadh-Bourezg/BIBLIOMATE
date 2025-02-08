import 'package:flutter/material.dart';
import 'package:project/SignUpPage.dart';
import '../SignInPage.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Common styling
    const Color primaryColor = Color(0xFF2979FF); // Example blue color

    // Dynamic padding based on screen width
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final verticalPadding = screenHeight * 0.02; // 2% of screen height

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: verticalPadding),
                // Top illustration (replace with your own asset if you have one)
                AspectRatio(
                  aspectRatio: 10 / 9, // Responsive aspect ratio
                  child: Image.asset(
                    'assets/library_illustration1.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: verticalPadding),
                // Logo + title
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Example logo icon – replace with your own if desired
                    CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: screenWidth * 0.05, // 5% of screen width
                      child: Icon(
                        Icons.book,
                        color: Colors.white,
                        size: screenWidth * 0.04, // 4% of screen width
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02), // 2% of screen width
                    Text(
                      'BIBLIOMATE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.05, // 5% of screen width
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: verticalPadding),
                // Headline
                Text(
                  'Everything you need is in one place',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06, // 6% of screen width
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
                SizedBox(height: verticalPadding / 2),
                // Subtitle / Description
                Text(
                  'Find your daily necessities at Brand. The world\'s largest fashion e-commerce has arrived in a mobile. Shop now!',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035, // 3.5% of screen width
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SignInPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      'SignIn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04, // 4% of screen width
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: verticalPadding),
                // Register button
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.08, // 8% of screen height
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            screenWidth * 0.2), // 2% of screen width
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SignUpPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      'SignUp',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // 4% of screen width
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
