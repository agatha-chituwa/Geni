import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:geni_app/login/signup.dart';
import 'package:geni_app/state_providers/book_provider.dart';
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
    await _initializeApp();
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
  
  _initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.playIntegrity,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Device Check provider
        // 3. App Attest provider
        // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );
    Provider.of<AuthProvider>(context, listen: false).initialize();
    await Provider.of<UsersProvider>(context, listen: false).init();
    await Provider.of<BookProvider>(context, listen: false).init();
  }
}
