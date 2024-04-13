import 'package:flutter/material.dart';
import 'package:geni_app/model/book_model.dart';
import 'package:geni_app/model/business_model.dart';
import 'package:geni_app/state_providers/book_provider.dart';
import 'package:provider/provider.dart';

class NewBook extends StatefulWidget {
  final Business? business;
  final Book? book;

  const NewBook({super.key, this.business, this.book});

  @override
  State<NewBook> createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.book?.name);
    _descriptionController = TextEditingController(text: widget.book?.description ?? '');
  }
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.book == null? 'New' : 'Update'} ${widget.business?.name} Book'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _loading? const CircularProgressIndicator() : Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Enter book name',
                    hintText: 'Enter book name ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Colors.green), // Use named color
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name for the book.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Write a brief description of the book',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Colors.green), // Use named color
                    ),
                  ),
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description for the book.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String name = _nameController.text;
                      String description = _descriptionController.text;
                      setState(() {
                        _loading = true;
                      });
                      if (widget.book == null) {
                        await Provider.of<BookProvider>(context, listen: false).addBookofBusiness(
                          Book(name: name, description: description, createdAt: DateTime.now(), updatedAt: DateTime.now()),
                          widget.business!.ref!
                        );
                      } else {
                        final book = widget.book!;
                        book.name = name;
                        book.description = description;
                        book.updatedAt = DateTime.now();
                        await Provider.of<BookProvider>(context, listen: false).updateBook(
                          book,
                        );
                      }
                      
                      setState(() {
                        _loading = false;
                      });
                      
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Set button background color
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
