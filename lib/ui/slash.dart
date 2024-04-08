import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:geni_app/login/signup.dart';
import 'package:geni_app/state_providers/book_provider.dart';
import 'package:geni_app/state_providers/business_provider.dart';
import 'package:geni_app/state_providers/users_provider.dart';
import 'package:geni_app/ui/home_page.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import '../firebase_options.dart';

class Slash extends StatefulWidget {
  const Slash({super.key});

  @override
  State<Slash> createState() => _SlashState();
}

class _SlashState extends State<Slash> {
  @override
  void initState() {
    super.initState();
  }

  _navigateToHome() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await _initializeApp(authProvider.currentUser?.phoneNumber);
    Navigator.pushReplacement(
        context, MaterialPageRoute(
          builder: (context) => authProvider.isSignedIn? const HomePage() : const Register()
        ));
  }

  @override
  Widget build(BuildContext context) {
    _navigateToHome();
    return const Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Image(image: AssetImage('assets/images/200 px.png')),
          )
        ],
      ),
    ));
  }
  
  _initializeApp(String? phoneNumber) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );
    Provider.of<AuthProvider>(context, listen: false).initialize();
    await Provider.of<UsersProvider>(context, listen: false).init();
    await Provider.of<BookProvider>(context, listen: false).init();
    await Provider.of<BusinessProvider>(context, listen: false).init(phoneNumber);
  }
}
