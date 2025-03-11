import 'package:flutter/material.dart';
import 'package:geni_app/model/business_member_model.dart';
import 'package:geni_app/model/business_book_model.dart';
import 'package:geni_app/state_providers/book_provider.dart';
import 'package:geni_app/state_providers/business_provider.dart';
import 'package:geni_app/ui/financial_book_page.dart';
import 'package:geni_app/ui/members_page.dart';
import 'package:provider/provider.dart';

import 'book_form.dart';
import 'entry_form.dart';

class BusinessDetailPage extends StatefulWidget {
  final BusinessMember business;

  const BusinessDetailPage({Key? key, required this.business}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BusinessDetailsState();
  }
}

class BusinessDetailsState extends State<BusinessDetailPage> {

  bool _deleting = false;
  late BusinessMember business;

  @override
  void initState() {
    super.initState();
    business = widget.business;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(business.business!.name),
        backgroundColor: const Color(0xFF19CA79),
        foregroundColor: Colors.white,
        actions: business.business?.numberOfEmployees == -101? null : [
          if (business.roleReference.id.toLowerCase() == 'owner')
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MembersPage(isBusiness: true, entity: business.business),
              ));
            },
            icon: const Icon(Icons.people),
          ),
          if (business.roleReference.id.toLowerCase() == 'owner')
            _buildMoreActions(context),
        ],
      ),
      body:  _deleting? const Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBusinessInfo(context),
            const SizedBox(height: 20),
            Expanded(child: _buildBooksList(context)),
          ],
        ),
      ),
      floatingActionButton: (business.roleReference.id.toLowerCase() != 'viewer') ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewBook(business: business.business)),
          ).then((value) => _refreshBooks(context));
        },
        backgroundColor: const Color(0xFF19CA79),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ) : null,
    );
  }

  Widget _buildMoreActions(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        if (value == 'delete') {
          _showDeleteConfirmationDialog(context);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete Business'),
          ),
        ];
      },
    );
  }

  Widget _buildBusinessInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Business Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Text(
          'Location: ${business.business!.location}',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          'Role: ${business.roleReference.id}',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildBooksList(BuildContext context) {
    return FutureBuilder<List<BusinessBook>>(
      future: Provider.of<BookProvider>(context).getBusinessBooks(business.businessReference),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error retrieving business books'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No books found.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          );
        } else {
          // Filter books based on membership and role
          return FutureBuilder<List<BusinessBook>>(
            future: _filterAccessibleBooks(snapshot.data!),
            builder: (context, filteredSnapshot) {
              if (filteredSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final books = filteredSnapshot.data ?? [];
              if (books.isEmpty) {
                return const Center(
                  child: Text(
                    'No accessible books found.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                );
              }

              books.sort((a, b) => b.book!.createdAt.millisecondsSinceEpoch
                  .compareTo(a.book!.createdAt.millisecondsSinceEpoch));

              return ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return _buildBookEntry(books[index], context);
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _buildBookEntry(BusinessBook book, BuildContext context) {
  return FutureBuilder<List<double>>(
    future: Provider.of<BookProvider>(context, listen: false).getBalances(book.book!),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: const ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            title: Text(
              'Loading...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Center(child: CircularProgressIndicator()),
          ),
        );
      } else if (snapshot.hasError) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: const ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            title: Text(
              'Error loading balance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );
      } else {
        final balances = snapshot.data!;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          color: balances[2] < 0 ? Colors.red[50] : Colors.blue[50],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FinancialBookPage(book: book.book!, role: business.roleReference.id.toLowerCase())),
              ).then((value) => _refreshBooks(context));
            },
            title: Text(
              book.book?.name ?? 'Unknown',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Balance (MWK):',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8,),
                Text(
                  balances[2].toString(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            trailing: (business.roleReference.id.toLowerCase() != 'viewer') ? PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewBook(business: business.business, book: book.book)),
                    ).then((value) => _refreshBooks(context));
                    break;
                  case 'add_cash_in':
                    _navigateToAddEntry(context, book, true);
                    break;
                  case 'add_cash_out':
                    _navigateToAddEntry(context, book, false);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                if (business.roleReference.id.toLowerCase() == 'owner')
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
            ) : null,
          ),
        );
      }
    },
  );
}
  void _navigateToAddEntry(BuildContext context, BusinessBook book, bool isCashIn) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EntryForm(book: book.book!, isCashIn: isCashIn)),
    ).then((value) => _refreshBooks(context));
  }

  void _refreshBooks(BuildContext context) {
    Provider.of<BookProvider>(context, listen: false).getBusinessBooks(business.businessReference);
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this business? This action cannot be undone.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _deleteBook();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteBook() {
    setState(() {
      _deleting = true;
    });
    Provider.of<BusinessProvider>(context, listen: false).deleteBusiness(business).then((e) {
      Navigator.of(context).pop();
    });
  }

  Future<List<BusinessBook>> _filterAccessibleBooks(List<BusinessBook> books) async {
    // Business owner can see all books

    if (business.roleReference.id.toLowerCase() == 'owner') {
      return books;
    }

    final filteredBooks = <BusinessBook>[];
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    for (var businessBook in books) {
      // Load book members if not already loaded
      await bookProvider.loadBookMembers(businessBook.book!);
      
      // Check if current user is a member of the book
      final isMember = businessBook.book!.members.any(
        (member) => member.userReference.id == business.userReference.id
      );

      if (isMember) {
        filteredBooks.add(businessBook);
      }
    }

    return filteredBooks;
  }
}