import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:geni_app/model/user_model.dart';
import 'package:geni_app/login/email_login.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF19CA79),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Color(0xFF19CA79),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: Text(
                user?.displayName ?? 'User Name',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildProfileItem('Email', user?.email ?? 'user@example.com'),
            const SizedBox(height: 10),
            _buildProfileItem('Phone', user?.phoneNumber ?? 'Not Available'),
            const SizedBox(height: 60),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () => _signOutUser(context),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  void _signOutUser(BuildContext context) async {
    final shouldSignOut = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out Confirmation'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Sign Out
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Login()));
    }
  }
}
