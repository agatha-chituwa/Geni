import 'package:flutter/material.dart';

class NewBook extends StatefulWidget {
  const NewBook({super.key});

  @override
  State<NewBook> createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

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
        title: const Text('Add New Book'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String name = _nameController.text;
                      String description = _descriptionController.text;

                      // Handle form submission logic here

                      _formKey.currentState!.reset();
                      _nameController.text = '';
                      _descriptionController.text = '';
                    }
                  },
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Set button background color
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
