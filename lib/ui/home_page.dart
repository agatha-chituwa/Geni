import 'package:flutter/material.dart';
import 'package:geni_app/ui/business_form.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:geni_app/state_providers/book_provider.dart';
import 'package:provider/provider.dart';

class ReusableCard extends StatelessWidget {
  final String companyName;
  final String bookName;
  final String price;
  final String buttonText; // New parameter for button text

  const ReusableCard({
    Key? key,
    required this.companyName,
    required this.bookName,
    required this.price,
    required this.buttonText, // Initialize button text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 50.0,
              ),
              SizedBox(
                height: 560,
                child: Card(
                  elevation: 0.5,
                  margin: const EdgeInsets.only(bottom: 60),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 100,
                      left: 16.0,
                      right: 16.0,
                      bottom: 20,
                    ),
                    child: Column(
                      children: [
                        Text(
                          companyName,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 50.0),
                        Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: Text(
                                    bookName,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 50.0),
                                  child: Text(
                                    price,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 0.0),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.person_outline),
                                  onPressed: () {},
                                ),
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Enter data...',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
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
                                    bookName,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 50.0),
                                  child: Text(
                                    price,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 0.0),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.person_outline),
                                  onPressed: () {},
                                ),
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Enter data...',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
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
          const SizedBox(
            height: 140,
            width: 120,
            child: Image(image: AssetImage('assets/images/200 px.png')),
          ),
          Positioned(
            bottom: 100,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF19CA79),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  buttonText, // Use the provided button text
                  style: const TextStyle(
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: const Color(0xFFEFE9E9),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              Column(
                children: [
                  for (final book in bookProvider.businessBooks) ...[]
                ],
              ),
              // ReusableCard(
              //   companyName: "Agatha",
              //   bookName: "book1",
              //   price: "20000",
              //   buttonText: "hello",
              // ),
              // ReusableCard(
              //   companyName: "Pempho",
              //   bookName: "book1",
              //   price: "20000",
              //   buttonText: "add book",
              // ),
            ],
          ),
          Positioned(
            top: 20,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (_pageController.page != 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          Positioned(
            top: 20,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                if (_pageController.page != 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add a new business
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => BusinessForm()));
        },
        backgroundColor: const Color(0xFF19CA79),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Business', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
