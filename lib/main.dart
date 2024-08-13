import 'package:flutter/material.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:geni_app/state_providers/book_provider.dart';
import 'package:geni_app/state_providers/business_provider.dart';
import 'package:geni_app/state_providers/users_provider.dart';
import 'package:geni_app/ui/slash.dart';
import 'package:provider/provider.dart';

main() {
  runApp(
    // Wrap your main app widget with ChangeNotifierProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => BookProvider()),
        ChangeNotifierProvider(create: (context) => BusinessProvider()),
        ChangeNotifierProvider(
          create: (context) => UsersProvider(),
        )
      ],
      child: const MyApp(), // Your main app widget
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geni',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Slash(),
    );
  }
}