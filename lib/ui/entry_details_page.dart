import 'package:flutter/material.dart';
import 'package:geni_app/model/book_model.dart';
import 'package:geni_app/model/entry_model.dart';
import 'package:geni_app/ui/entry_form.dart';
import 'package:geni_app/state_providers/book_provider.dart';
import 'package:provider/provider.dart';


class EntryDetailsPage extends StatefulWidget {
  final Entry entry;
  final Book book;
  final String role;

  const EntryDetailsPage({Key? key, required this.entry, required this.book, required this.role}) : super(key: key);

  @override
  State<EntryDetailsPage> createState() => _EntryDetailsPageState();
}

class _EntryDetailsPageState extends State<EntryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.book.name} Entry Details'),
        backgroundColor: const Color(0xFF19CA79),
        foregroundColor: Colors.white,
        actions: [
          if (widget.role != "viewer")
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _editEntry();
              } else if (value == 'delete') {
                _confirmDeletion(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice.toLowerCase(),
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200], // Set the background color here
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.entry.isCashIn ? 'Cash In' : 'Cash Out',
                          style: TextStyle(
                            color: widget.entry.isCashIn ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        _buildDetailRow('Amount', 'MK ${widget.entry.amount}', isBold: true, valueColor: widget.entry.isCashIn ? Colors.green : Colors.red),
                        const SizedBox(height: 20.0),
                        _buildDetailRow('Description', widget.entry.description),
                        const SizedBox(height: 20.0),
                        _buildDetailRow('Payment Mode', widget.entry.paymentModeRef.id),
                        const SizedBox(height: 20.0),
                        _buildDetailRow('Entered By', widget.entry.bookMemberRef.id),
                        const SizedBox(height: 20.0),
                        _buildDetailRow('Date', '${widget.entry.updatedAt.year}-${widget.entry.updatedAt.month}-${widget.entry.updatedAt.day}'),
                        const SizedBox(height: 20.0),
                        _buildDetailRow('Time', '${widget.entry.updatedAt.hour}:${widget.entry.updatedAt.minute}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Entry'),
          content: const Text('Are you sure you want to delete this entry?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteEntry();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteEntry() async {
    Navigator.of(context).pop(); // Close the dialog

    await Provider.of<BookProvider>(context, listen: false).deleteEntry(widget.entry, widget.book);
    Navigator.of(context).pop(); // Close the entry details page
  }

  void _editEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntryForm(
          isCashIn: widget.entry.isCashIn,
          book: widget.book,
          entry: widget.entry,
        ),
      ),
    ).then((_) {
      setState(() {

      });
    });
  }
}
