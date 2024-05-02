import 'package:flutter/material.dart';
import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/login/email_login.dart';
import 'package:geni_app/model/business_book_model.dart';
import 'package:geni_app/model/business_member_model.dart';
import 'package:geni_app/model/business_model.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:geni_app/state_providers/book_provider.dart';
import 'package:geni_app/state_providers/business_provider.dart';
import 'package:geni_app/ui/book_form.dart';
import 'package:geni_app/ui/business_form.dart';
import 'package:geni_app/ui/entry_form.dart';
import 'package:provider/provider.dart';

class BusinessCard extends StatefulWidget {
  final BusinessMember business;

  const BusinessCard({
    Key? key,
    required this.business,
  }) : super(key: key);

  @override
  State<BusinessCard> createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
  late Future<List<BusinessBook>> booksFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    booksFuture = getBooks();
  }

  @override
  void didUpdateWidget(covariant BusinessCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.business.business?.name != oldWidget.business.business?.name) {
      setState(() {
        booksFuture = getBooks();
      });
    }
  }

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
                width: double.infinity,
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
                          widget.business.business!.name,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 50.0),
                        FutureBuilder(
                            future: booksFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return const Center(
                                  child: Text('Error'),
                                );
                              } else {
                                return Column(
                                  children: [
                                    for (final book in snapshot.data!)
                                      _buildBookEntry(book)
                                  ],
                                );
                              }
                            }),
                        const SizedBox(
                          height: 30,
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) => NewBook(
                            business: widget.business.business,
                          ),
                        ))
                        .then((value) => booksFuture = getBooks());
                  },
                  child: const Text(
                    "Add New Book", // Use the provided button text
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<BusinessBook>> getBooks() {
    return Provider.of<BookProvider>(context, listen: false)
        .getBusinessBooks(widget.business.businessReference);
  }

  _buildBookEntry(BusinessBook book) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text(
                book.book?.name ?? "Unknown",
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Text(
                '${book.book?.balance}',
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
              child: Text(
                book.book?.description ?? "Book Description",
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                // Implement actions based on the selected option
                switch (value) {
                  case 'edit':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewBook(
                                business: widget.business.business,
                                book: book.book,
                              )),
                    ).then((value) => booksFuture = getBooks());
                    break;
                  case 'add_cash_in':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EntryForm(
                                book: book.book!,
                                isCashIn: true,
                              )),
                    ).then((value) => booksFuture = getBooks());
                    break;
                  case 'add_cash_out':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EntryForm(
                                book: book.book!,
                                isCashIn: false,
                              )),
                    ).then((value) => booksFuture = getBooks());
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem<String>(
                  value: 'add_cash_in',
                  child: Text('Add Cash In'),
                ),
                const PopupMenuItem<String>(
                  value: 'add_cash_out',
                  child: Text('Add Cash Out'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BusinessMember? _business;

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<BusinessProvider>(context)
      ..loadUserBusinesses(DataModel().usersCollection.doc(
          Provider.of<AuthProvider>(context, listen: false)
              .currentUser!
              .email!));
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _signOutUser(authProvider);
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFEFE9E9),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 140,
                        width: 120,
                        child: Image(
                            image: AssetImage('assets/images/200 px.png')),
                      )),
                ],
              ),
            ),
            ExpansionTile(
              title: Text(
                'Businesses',
                style: TextStyle(fontWeight: FontWeight.bold) ,
                ),
              children: [
                for (final business in businessProvider.userBusinesses)
                  ListTile(
                    title: Text(business.business!.name),
                    onTap: () {
                      setState(() {
                        _business = business;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
            const ExpansionTile(
              title: Text('Books', style: TextStyle(fontWeight: FontWeight.bold),),
              children: [
                
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          if (businessProvider.isLoading &&
              businessProvider.userBusinesses.isEmpty)
            const CircularProgressIndicator(),
          if (!businessProvider.isLoading &&
              businessProvider.userBusinesses.isEmpty)
            const Text(
                "You don not have any business.\n Click + Business to register a business"),
          if (businessProvider.userBusinesses.isNotEmpty) ...[
            BusinessCard(
                business: _business ?? businessProvider.userBusinesses.first,
            ),
          ]
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add a new business
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const BusinessForm()),
          );
        },
        backgroundColor: const Color(0xFF19CA79),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Business', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _signOutUser(AuthProvider authProvider) async {
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
      await authProvider.signOut();
      Navigator.of(context).popUntil(
          (route) => route.isFirst); 
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Login()));
    }
  }
}
