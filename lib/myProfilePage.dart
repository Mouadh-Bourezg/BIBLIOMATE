import 'package:flutter/material.dart';
import 'components/bottomBar.dart';
import 'accountInfo.dart'; // Import the AccountInfoPage

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.blue,
                          size: screenWidth * 0.05,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Greeting
            const Text(
              'Profile', // Placeholder for the user's name
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            // Account Information Option
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: const Text('Account Information'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountInfoPage(), // Navigate to AccountInfoPage
                  ),
                );
              },
            ),
            const Divider(thickness: 1),
            // Downloads Option
            ListTile(
              leading: const Icon(Icons.download_rounded),
              title: const Text('Downloads'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle navigation
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 4,
        onItemSelected: (index) {
          // Handle navigation
        },
      ),
    );
  }
}