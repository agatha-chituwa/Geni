import 'package:flutter/material.dart';
import 'package:geni_app/login/signup.dart';

import 'package:firebase_core/firebase_core.dart';
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
    _navigateToHome();
  }

  _navigateToHome() async {
    await _initializeApp();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Register()));
  }

  @override
  Widget build(BuildContext context) {
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
  
  _initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
