import 'package:flutter/material.dart';
import 'components/bottomBar.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            // Profile Image and Greeting
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Replace with actual image URL
            ),
            SizedBox(height: 10),
            Text(
              'Hi, mouadh.bourezg',
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
                // Handle navigation
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