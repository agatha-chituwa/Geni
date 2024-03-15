import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class BusinessForm extends StatefulWidget {
  const BusinessForm({Key? key}) : super(key: key);

  @override
  _BusinessFormState createState() => _BusinessFormState();
}

class _BusinessFormState extends State<BusinessForm> {
  final _formKey = GlobalKey<FormState>();

  String _businessName = "";
  int _numberOfEmployees = 0;
  String _location = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Logo/Company Name
              const Center(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Text(
                    'Infinity\nMedia Group',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),

              // Business Name Field
              TextFormField(
                validator: RequiredValidator(errorText: 'Please enter a business name'),
                decoration: const InputDecoration(
                  labelText: 'Type of Business',
                ),
                onChanged: (value) => setState(() => _businessName = value),
              ),

              // Number of Employees Field
              TextFormField(
                validator: RequiredValidator(errorText: 'Please enter the number of employees'),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of Employees',
                ),
                onChanged: (value) => setState(() => _numberOfEmployees = int.parse(value)),
              ),

              // Location Field
              TextFormField(
                validator: RequiredValidator(errorText: 'Please enter a location'),
                decoration: const InputDecoration(
                  labelText: 'Location',
                ),
                onChanged: (value) => setState(() => _location = value),
              ),

              // Add Members Button (Consider removing if not needed)
              const Center(
                child: SizedBox(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: null,
                    child: Text('Add Members'), // Implement functionality for adding members
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Skip Button
              Center(
                child: TextButton(
                  child: const Text('Skip'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
