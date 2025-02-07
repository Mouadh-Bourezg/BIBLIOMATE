import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'package:project/HomePage.dart';

class SignUpPage extends StatelessWidget {
  static final pageRoute = '/SignUp';
  SignUpPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  Future<void> _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Perform sign-up action
        final response = await Supabase.instance.client.auth.signUp(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Check if the response contains an error
        if (response.user == null) {
          throw Exception('Sign-Up Failed');
        }

        // Sign-Up successful, store additional user information in the users table
        final user = response.user;

        // Insert user details into the `users` table
        final insertResponse = await Supabase.instance.client.from('users').insert([
          {
            'id': user?.id,  // Use the user ID from the authentication response
            'first_name': firstnameController.text.trim(),
            'last_name': lastnameController.text.trim(),
            'email': emailController.text.trim(),
          }
        ]);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-Up Successful')),
        );

        // Navigate back to the previous page or to the HomePage
        Navigator.of(context).pop({
          "email": emailController.text,
          "password": passwordController.text,
        });
      } catch (e) {
        // Handle any exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-Up Error: ${e.toString()}')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(90.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30,),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),

                // Email Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email address',
                    prefixIcon: const Icon(Icons.email),
                    labelStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87.withOpacity(0.3),
                    ),
                    filled: true,
                    fillColor: Colors.black87.withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // First Name Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: const Icon(Icons.person),
                    labelStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87.withOpacity(0.3),
                    ),
                    filled: true,
                    fillColor: Colors.black87.withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  controller: firstnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Invalid First Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Last Name Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: const Icon(Icons.person),
                    labelStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87.withOpacity(0.3),
                    ),
                    filled: true,
                    fillColor: Colors.black87.withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  controller: lastnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Invalid Last Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password Field
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    labelStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87.withOpacity(0.3),
                    ),
                    filled: true,
                    fillColor: Colors.black87.withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password Field
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock),
                    labelStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87.withOpacity(0.3),
                    ),
                    filled: true,
                    fillColor: Colors.black87.withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Submit Button
                Center(
                  child: Container(
                    width: 120,
                    height: 40,
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => _signUp(context), // Call sign-up logic
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text('Already have an account ?',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue
                      ),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}