import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project/services/userServices.dart'; // Import UserService
import 'package:project/myDocumentsPage.dart'; // Import MyDocumentsPage

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({super.key});

  @override
  _AccountInfoPageState createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  final UserService _userService = UserService(Supabase.instance.client);
  Map<String, String> _userInfo = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo(); // Fetch user information when the page is initialized
  }

  Future<void> _fetchUserInfo() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id; // Get current user ID
      if (userId != null) {
        _userInfo = await _userService.getUserInformation(userId);
      }
    } catch (e) {
      print('Error fetching user information: $e');
    } finally {
      setState(() {
        _isLoading = false; // Update loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: _userInfo['profile_picture'] != null
                  ? NetworkImage(_userInfo['profile_picture']!)
                  : const AssetImage('assets/default_profile.png') as ImageProvider,
              child: _userInfo['profile_picture'] == null
                  ? const Icon(Icons.person, size: 60, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              'Hi, ${_userInfo['first_name']} ${_userInfo['last_name']}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${_userInfo['email']}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.blueAccent),
                      title: const Text('Email'),
                      subtitle: Text('${_userInfo['email']}'),
                    ),
                    const Divider(thickness: 1),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.blueAccent),
                      title: const Text('Phone'),
                      subtitle: Text(_userInfo['phone'] ?? 'Not provided'),
                    ),
                    const Divider(thickness: 1),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.folder, color: Colors.blueAccent),
                title: const Text('My Documents'),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                onTap: () {
                  // Navigate to MyDocumentsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyDocumentsPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}