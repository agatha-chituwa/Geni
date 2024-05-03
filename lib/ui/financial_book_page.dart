import 'package:flutter/material.dart';
import 'package:geni_app/model/book_model.dart';
import 'package:geni_app/state_providers/book_provider.dart';
import 'package:geni_app/model/entry_model.dart';
import 'package:geni_app/ui/entry_form.dart';
import 'package:provider/provider.dart';

class FinancialBookPage extends StatefulWidget {
  final Book book;

  const FinancialBookPage({Key? key, required this.book}) : super(key: key);

  @override
  _FinancialBookPageState createState() => _FinancialBookPageState();
}

class _FinancialBookPageState extends State<FinancialBookPage> {
  late Future<List<Entry>> _entriesFuture;

  @override
  void initState() {
    super.initState();
    _entriesFuture = _getEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteBook();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Entry>>(
        future: _entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Entry> entries = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Book Balance',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        'MK ${widget.book.balance}',
                        style: const TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Total Cash In',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                      Text(
                        'MK ${widget.book.totalCashIn}',
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Total Cash Out',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                      Text(
                        'MK ${widget.book.totalCashOut}',
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final Entry entry = entries[index];
                      return ListTile(
                        title: Text(entry.description),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MK ${entry.amount}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Entered By: ${entry.bookMemberRef.id}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  '${entry.updatedAt.year}/${entry.updatedAt.month}/${entry.updatedAt.day}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton.extended(
            heroTag: 'cash_in_button', // Unique tag for the Cash In button
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EntryForm(
                      book: widget.book,
                      isCashIn: true,
                    ),
                  ),
                ).then((value) => _entriesFuture = _getEntries());
            },
            label: const Text('Cash In', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
            icon: const Icon(Icons.add, color: Colors.white,),
            backgroundColor: Colors.green,
          ),
          const SizedBox(height: 8.0),
          FloatingActionButton.extended(
            heroTag: 'cash_out_button', // Unique tag for the Cash Out button
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EntryForm(
                      book: widget.book,
                      isCashIn: false,
                    ),
                  ),
                ).then((value) => _entriesFuture = _getEntries());
            },
            label: const Text('Cash Out', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
            icon: const Icon(Icons.remove, color: Colors.white,),
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  void _deleteBook() {}

  Future<List<Entry>> _getEntries() {
    return Provider.of<BookProvider>(context, listen: false)
        .getEntriesOfBook(widget.book.ref!);
  }
}
