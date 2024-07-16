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
        backgroundColor: const Color(0xFF19CA79),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmationDialog(context),
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
                _buildBookInfo(),
                Expanded(
                  child: ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final Entry entry = entries[index];
                      return _buildEntryTile(entry);
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: _buildFABs(),
    );
  }

  Widget _buildBookInfo() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Book Balance', 'MK ${widget.book.balance}', isBold: true, valueFontSize: 24.0),
          const SizedBox(height: 10.0),
          _buildInfoRow('Total Cash In', 'MK ${widget.book.totalCashIn}', valueColor: Colors.green),
          const SizedBox(height: 10.0),
          _buildInfoRow('Total Cash Out', 'MK ${widget.book.totalCashOut}', valueColor: Colors.red),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, double valueFontSize = 20.0, Color? valueColor}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? (isBold ? Colors.black : Colors.grey[700]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEntryTile(Entry entry) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        title: Text(
          entry.description,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Amount: ',
                  style: TextStyle(color: Colors.grey),
                ),
                Expanded(
                  child: Text(
                    'MK ${entry.amount}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Text(
                  'Entered By: ',
                  style: TextStyle(color: Colors.grey),
                ),
                Expanded(
                  child: Text(
                    entry.bookMemberRef.id,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Text(
                  'Date: ',
                  style: TextStyle(color: Colors.grey),
                ),
                Expanded(
                  child: Text(
                    '${entry.updatedAt.year}/${entry.updatedAt.month}/${entry.updatedAt.day}',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFABs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ).then((value) => setState(() {
              _entriesFuture = _getEntries();
            }));
          },
          label: const Text(
            'Cash In',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          icon: const Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.green,
        ),
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
            ).then((value) => setState(() {
              _entriesFuture = _getEntries();
            }));
          },
          label: const Text(
            'Cash Out',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          icon: const Icon(Icons.remove, color: Colors.white),
          backgroundColor: Colors.red,
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this book? This action cannot be undone.'),
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
    // Implement book deletion logic
    Provider.of<BookProvider>(context, listen: false)
        .deleteBook(widget.book);
    Navigator.of(context).pop(); // Go back to the previous screen
  }

  Future<List<Entry>> _getEntries() {
    return Provider.of<BookProvider>(context, listen: false)
        .getEntriesOfBook(widget.book.ref!);
  }
}
