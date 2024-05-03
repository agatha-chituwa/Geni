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

  const EntryForm(
      {Key? key, required this.isCashIn, required this.book, this.entry})
      : super(key: key);

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
    _selectedDate = DateTime.now();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white, // Set the background color here
          child: Padding(
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
                      child: Card(
                        elevation: 0.5,
                        margin: const EdgeInsets.only(bottom: 60),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 16.0,
                            right: 16.0,
                            bottom: 20,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Date and Time
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Date: ${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
                                    Text(
                                        'Time: ${_selectedTime.hour}:${_selectedTime.minute}'),
                                  ],
                                ),

                                const SizedBox(height: 60),

                                SizedBox(
                                  width: double.maxFinite,
                                  child: Text(
                                    _title,
                                    style: TextStyle(
                                        color: widget.isCashIn
                                            ? Colors.green[400]
                                            : Colors.red[400],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 24),
                                    textAlign: TextAlign.left,
                                  ),
                                ),

                                const SizedBox(
                                  height: 30,
                                ),

                                // Amount Field
                                TextFormField(
                                  initialValue: _amount.toString(),
                                  validator: RequiredValidator(
                                      errorText: 'Please enter an amount'),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Amount',
                                  ),
                                  onChanged: (value) => setState(() => _amount =
                                      value.isNotEmpty
                                          ? double.parse(value)
                                          : 0),
                                ),

                                const SizedBox(height: 20),

                                // Description Field
                                TextFormField(
                                  initialValue: _description,
                                  validator: RequiredValidator(
                                      errorText: 'Please enter a description'),
                                  decoration: const InputDecoration(
                                    labelText: 'Description',
                                  ),
                                  onChanged: (value) =>
                                      setState(() => _description = value),
                                ),

                                const SizedBox(height: 20),

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
                                  ),
                                ),

                                const SizedBox(height: 40),

                                // Save and Add New Button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed:
                                            _isLoading ? null : _saveEntry,
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20), // Adjust the border radius as needed
                                          ),
                                          // Add your desired background color here
                                          backgroundColor: _isLoading
                                              ? Colors.grey
                                              : widget.isCashIn
                                            ? Colors.green[600]
                                            : Colors.red[600],
                                        ),
                                        child: _isLoading
                                            ? const CircularProgressIndicator()
                                            : const Text(
                                                'Save',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                ),
                                              ),
                                      ),
                                    ),

                                    // ElevatedButton(
                                    //   onPressed: _isLoading ? null : _saveAndAddNew,
                                    //   child: _isLoading ? const CircularProgressIndicator() : const Text('Save & Add New'),
                                    // ),
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
                // const SizedBox(
                //   height: 140,
                //   width: 120,
                //   child: Image(image: AssetImage('assets/images/200 px.png')),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });
      final entry = Entry(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isCashIn: widget.isCashIn,
        amount: _amount,
        description: _description,
        bookMemberRef: DataModel().usersCollection.doc(
            Provider.of<AuthProvider>(context, listen: false)
                .currentUser
                ?.email),
        paymentModeRef: DataModel().paymentModeCollection.doc(_paymentMode),
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
