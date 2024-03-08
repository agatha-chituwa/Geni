import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _authProvider.signOut();
              //Navigator.pushReplacementNamed('/login'); // Replace with your login screen route
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _authProvider.isSignedIn ? 'Welcome, ${_authProvider.currentUser?.phoneNumber}' : 'Please sign in',
              style: TextStyle(fontSize: 24.0),
            ),
            // Add other UI elements based on your application's functionality
          ],
        ),
      ),
    );
  }
}