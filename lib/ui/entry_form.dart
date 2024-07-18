import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geni_app/model/book_model.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:geni_app/state_providers/book_provider.dart';
import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/model/entry_model.dart';
import 'package:provider/provider.dart';

class EntryForm extends StatefulWidget {
  final bool isCashIn;
  final Entry? entry;
  final Book book;

  const EntryForm({
    Key? key,
    required this.isCashIn,
    required this.book,
    this.entry,
  }) : super(key: key);

  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _title;
  late double _amount;
  late String _description;
  late String _paymentMode;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.entry?.createdAt ?? DateTime.now();
    _selectedTime = TimeOfDay.now();
    _title = widget.isCashIn ? 'Cash In' : 'Cash Out';
    _amount = widget.entry?.amount ?? 0;
    _description = widget.entry?.description ?? '';
    _paymentMode = widget.entry?.paymentModeRef.id ?? 'Cash';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.book.name} Book Entry'),
        backgroundColor: const Color(0xFF19CA79),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                child: ConstrainedBox(

                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 16.0,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Date and Time
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Date: ${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                      Text(
                                        'Time: ${_selectedTime.hour}:${_selectedTime.minute}',
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 30.0),

                                  Text(
                                    _title,
                                    style: TextStyle(
                                      color: widget.isCashIn ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),

                                  const SizedBox(height: 30.0),

                                  // Amount Field
                                  TextFormField(
                                    initialValue: widget.entry == null? null : _amount.toString(),
                                    validator: RequiredValidator(
                                        errorText: 'Please enter an amount'),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Amount',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) => setState(
                                            () => _amount = value.isNotEmpty
                                            ? double.parse(value)
                                            : 0),
                                  ),

                                  const SizedBox(height: 20.0),

                                  // Description Field
                                  TextFormField(
                                    initialValue: _description,
                                    validator: RequiredValidator(
                                        errorText: 'Please enter a description'),
                                    decoration: const InputDecoration(
                                      labelText: 'Description',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) =>
                                        setState(() => _description = value),
                                  ),

                                  const SizedBox(height: 20.0),

                                  // Payment Mode Field (Dropdown)
                                  DropdownButtonFormField<String>(
                                    value: _paymentMode,
                                    items: [
                                      'Cash',
                                      'Credit Card',
                                      'Debit Card',
                                      'Online Transfer'
                                    ].map((String mode) {
                                      return DropdownMenuItem<String>(
                                        value: mode,
                                        child: Text(mode),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) => setState(
                                            () => _paymentMode = value ?? ''),
                                    decoration: const InputDecoration(
                                      labelText: 'Payment Mode',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),

                                  const SizedBox(height: 30.0),

                                  // Save and Add New Button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: _isLoading ? null : _saveEntry,
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            backgroundColor: widget.isCashIn
                                                ? Colors.green
                                                : Colors.red,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0),
                                          ),
                                          child: _isLoading
                                              ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                              : const Text(
                                            'Save',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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

  Future<void> _saveEntry() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });
      final entry = Entry(
        createdAt: _selectedDate,
        updatedAt: DateTime.now(),
        isCashIn: widget.isCashIn,
        amount: _amount,
        description: _description,
        bookMemberRef: DataModel().usersCollection.doc(
            Provider.of<AuthProvider>(context, listen: false).currentUser?.email),
        paymentModeRef: DataModel().paymentModeCollection.doc(_paymentMode),
        ref: widget.entry?.ref
      );

      // Use BookProvider to save the entry
      await Provider.of<BookProvider>(context, listen: false)
          .addBookEntry(widget.book, entry);
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  void _saveAndAddNew() {
    if (_formKey.currentState?.validate() == true) {
      _saveEntry();
      setState(() {
        _amount = 0;
        _description = '';
        _paymentMode = 'Cash';
      });
    }
  }
}
