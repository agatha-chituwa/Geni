import 'package:flutter/material.dart';
import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/model/business_member_model.dart';
import 'package:geni_app/model/business_book_model.dart';
import 'package:geni_app/state_providers/book_provider.dart';
import 'package:geni_app/ui/financial_book_page.dart';
import 'package:provider/provider.dart';

import 'book_form.dart';
import 'entry_form.dart';

class BusinessDetailPage extends StatelessWidget {
  final BusinessMember business;

  const BusinessDetailPage({Key? key, required this.business}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(business.business!.name),
        backgroundColor: const Color(0xFF19CA79),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.people),
          ),
        ],
      ),
      body: Padding(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewBook(business: business.business)),
          ).then((value) => _refreshBooks(context));
        },
        backgroundColor: const Color(0xFF19CA79),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
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
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No books found.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final book = snapshot.data![index];
              return _buildBookEntry(book, context);
            },
          );
        }
      },
    );
  }

  Widget _buildBookEntry(BusinessBook book, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FinancialBookPage(book: book.book!)),
          ).then((value) => _refreshBooks(context));
        },
        title: Text(
          book.book?.name ?? 'Unknown',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Balance:',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              book.book?.balance.toString() ?? '0',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
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
      ),
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
}