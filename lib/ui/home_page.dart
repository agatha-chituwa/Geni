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
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFEFE9E9),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    SizedBox(
                      height: 500,
                      child: Card(
                        elevation: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 100, left: 16.0, right: 16.0, bottom: 16.0),
                          child: Column(
                            children: [
                              Text(
                                "Infinity media group",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 50.0),
                              Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50.0),
                                        child: Text(
                                          'book1',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      // Spacer to distribute remaining space evenly between label and text
                                      Spacer(),

                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 50.0),
                                        child: Text(
                                          '20000',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 0.0),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.person_outline),
                                        onPressed: () {},
                                      ),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Enter data...',
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.more_vert),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50.0),
                                        child: Text(
                                          'book1',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 50.0),
                                        child: Text(
                                          '20000',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 0.0),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.person_outline),
                                        onPressed: () {},
                                      ),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Enter data...',
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.more_vert),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 140,
                  width: 120,
                  child: Image(image: AssetImage('assets/images/200 px.png')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
