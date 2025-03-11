import 'package:flutter/material.dart';
import 'package:geni_app/model/book_model.dart';
import 'package:geni_app/model/business_model.dart';
import 'package:geni_app/model/business_member_model.dart';
import 'package:geni_app/model/user_book_model.dart';
import 'package:geni_app/state_providers/book_provider.dart';
import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/state_providers/business_provider.dart';
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
  List<BusinessMember> _selectedMembers = [];
  List<BusinessMember> _availableMembers = [];
  final Map<BusinessMember, String> _memberRoles = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.book?.name);
    _descriptionController = TextEditingController(text: widget.book?.description ?? '');
    _loadMembers();
  }

  void _loadMembers() async {
    if (widget.business != null) {
      setState(() => _loading = true);
      
      // Load business members
      final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
      await businessProvider.loadBusinessMembers(widget.business!);
      _availableMembers = widget.business!.members.where((m) => m.roleReference.id != 'owner').toList();

      if (widget.book != null) {
        // Load book members when editing
        final bookProvider = Provider.of<BookProvider>(context, listen: false);
        await bookProvider.loadBookMembers(widget.book!);

        // Pre-select existing members
        for (var bookMember in widget.book!.members) {
          try {
            var businessMember = _availableMembers.firstWhere(
            (m) => m.userReference.id == bookMember.userReference.id,
          );
          if (businessMember != null) {
            _selectedMembers.add(businessMember);
            _memberRoles[businessMember] = bookMember.roleReference.id;
          }
          } catch (e) {
            print('Error: $e');
          }
        }
      }
      
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildMembersList() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assign Members',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _availableMembers.length,
              itemBuilder: (context, index) {
                final member = _availableMembers[index];
                final isSelected = _selectedMembers.contains(member);
                
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected ? Colors.green : Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(member.member?.name ?? 'Unknown'),
                    subtitle: Text(member.member?.email ?? ''),
                    trailing: isSelected? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    selected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedMembers.remove(member);
                          _memberRoles.remove(member);
                        } else {
                          _selectedMembers.add(member);
                          _memberRoles[member] = 'viewer';
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBook() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      try {
        String name = _nameController.text;
        String description = _descriptionController.text;

        if (widget.book == null) {
          // Create new book
          final book = Book(
            name: name, 
            description: description, 
            createdAt: DateTime.now(), 
            updatedAt: DateTime.now()
          );
          
          await Provider.of<BookProvider>(context, listen: false)
              .addBookofBusiness(book, widget.business!.ref!);

          // Add member associations
          for (var member in _selectedMembers) {
            await Provider.of<BookProvider>(context, listen: false).addUserBook(
              UserBook(
                userReference: member.userReference,
                roleReference: DataModel().rolesCollection.doc(_memberRoles[member]),
                bookReference: book.ref!,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );
          }
        } else {
          // Update existing book
          final book = widget.book!;
          book.name = name;
          book.description = description;
          book.updatedAt = DateTime.now();
          
          await Provider.of<BookProvider>(context, listen: false).updateBook(book);

          // Update member associations
          // First remove all existing associations
          for (var member in book.members) {
            await Provider.of<BookProvider>(context, listen: false)
                .removeUserBook(member);
          }

          // Then add new associations
          for (var member in _selectedMembers) {
            await Provider.of<BookProvider>(context, listen: false).addUserBook(
              UserBook(
                userReference: member.userReference,
                roleReference: DataModel().rolesCollection.doc(_memberRoles[member]),
                bookReference: book.ref!,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );
          }
        }

        if (mounted) Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.book == null? 'New' : 'Update'} ${widget.business?.name} Book'),
        backgroundColor: const Color(0xFF19CA79),
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Enter book name',
                                hintText: 'Enter book name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: const Icon(Icons.book),
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
                                ),
                                prefixIcon: const Icon(Icons.description),
                              ),
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a description for the book.';
                                }
                                return null;
                              },
                            ),
                            _buildMembersList(),
                            const SizedBox(height: 16.0),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _saveBook,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF19CA79),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  widget.book == null ? 'Create Book' : 'Update Book',
                                  style: const TextStyle(fontSize: 16),
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
      ),
    );
  }
}
