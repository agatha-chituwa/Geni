import 'package:flutter/material.dart';
import 'package:geni_app/login/email_login.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:geni_app/ui/business_form.dart';
import 'package:geni_app/ui/faq_page.dart';
import 'package:geni_app/ui/profile_page.dart';
import 'package:provider/provider.dart';

import 'business_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    BusinessListPage(),
    FAQPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0? 'Businesses' : 'Frequently Asked Questions'),
        backgroundColor: const Color(0xFF19CA79),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage()
                ),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'FAQ',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const BusinessForm()),
          );
        },
        backgroundColor: const Color(0xFF19CA79),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Business', style: TextStyle(color: Colors.white)),
      )
          : null,
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
