import 'package:flutter/material.dart';
import 'components/bottomBar.dart';
import 'accountInfo.dart'; // Import the AccountInfoPage

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            // Greeting
            Text(
              'Profile', // Placeholder for the user's name
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Divider(thickness: 1),
            // Account Information Option
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('Account Information'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountInfoPage(), // Navigate to AccountInfoPage
                  ),
                );
              },
            ),
            Divider(thickness: 1),
            // Downloads Option
            ListTile(
              leading: Icon(Icons.download_rounded),
              title: Text('Downloads'),
              trailing: Icon(Icons.arrow_forward_ios),
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