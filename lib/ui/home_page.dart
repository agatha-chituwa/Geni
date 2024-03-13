import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);

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
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              buildCard(),
              buildCard1(),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (_pageController.page != 0) {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                if (_pageController.page != 1) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
              SizedBox(
                height: 560, // Increased height to accommodate the button
                child: Card(
                  elevation: 0.5,
                  margin: EdgeInsets.only(
                      bottom:
                          60), // Adjusted margin to make space for the button
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 100,
                        left: 16.0,
                        right: 16.0,
                        bottom:
                            20), // Reduced bottom padding to make space for the button
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
                                  padding: const EdgeInsets.only(left: 50.0),
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
                                  padding: const EdgeInsets.only(right: 50.0),
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
                                  padding: const EdgeInsets.only(left: 50.0),
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
                                  padding: const EdgeInsets.only(right: 50.0),
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
          Positioned(
            bottom: 100,
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.4, // Adjust the width of the button here
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF19CA79),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  'Add book',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard1() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
              SizedBox(
                height: 560, // Increased height to accommodate the button
                child: Card(
                  elevation: 0.5,
                  margin: EdgeInsets.only(
                      bottom:
                          60), // Adjusted margin to make space for the button
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 100,
                        left: 16.0,
                        right: 16.0,
                        bottom:
                            20), // Reduced bottom padding to make space for the button
                    child: Column(
                      children: [
                        Text(
                          "Another One",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 50.0),
                        Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
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
                                  padding: const EdgeInsets.only(right: 50.0),
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
                                  padding: const EdgeInsets.only(left: 50.0),
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
                                  padding: const EdgeInsets.only(right: 50.0),
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
          Positioned(
            bottom: 100,
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.4, // Adjust the width of the button here
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF19CA79),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  'Add book',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
