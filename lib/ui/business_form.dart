import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/model/business_model.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:geni_app/state_providers/business_provider.dart';
import 'package:provider/provider.dart';

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

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Form'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
                      height: 560,
                      child: Card(
                        elevation: 0.5,
                        margin: const EdgeInsets.only(bottom: 60),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 100,
                            left: 16.0,
                            right: 16.0,
                            bottom: 20,
                          ),
                          child: Column(
                            children: [
                              // Business Name Field
                              TextFormField(
                                validator: RequiredValidator(
                                    errorText: 'Please enter a business name'),
                                decoration: const InputDecoration(
                                  labelText: 'Name Business',
                                ),
                                onChanged: (value) =>
                                    setState(() => _businessName = value),
                              ),

                              const SizedBox(height: 20),

                              // Number of Employees Field
                              TextFormField(
                                validator: RequiredValidator(
                                    errorText:
                                        'Please enter the number of employees'),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Number of Employees',
                                ),
                                onChanged: (value) => setState(() =>
                                    _numberOfEmployees = int.parse(value)),
                              ),

                              const SizedBox(height: 20),

                              // Location Field
                              TextFormField(
                                validator: RequiredValidator(
                                    errorText: 'Please enter a location'),
                                decoration: const InputDecoration(
                                  labelText: 'Location',
                                ),
                                onChanged: (value) =>
                                    setState(() => _location = value),
                              ),

                              const SizedBox(height: 20),

                              // Register Business
                              Center(
                                child: SizedBox(
                                  child: ElevatedButton(
                                    
                                    onPressed: _isLoading? null : () async {
                                      if (_formKey.currentState?.validate() != false) {
                                        debugPrint("Saving");
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        await Provider.of<BusinessProvider>(context, listen: false)
                                          .addBusiness(
                                            Business(
                                              createdAt: DateTime.now(),
                                              updatedAt: DateTime.now(),
                                              name: _businessName,
                                              location: _location,
                                              numberOfEmployees: _numberOfEmployees,
                                            ),
                                            DataModel().usersCollection.doc(
                                              Provider.of<AuthProvider>(context, listen: false).currentUser!.email!
                                            )
                                          );
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: _isLoading? const CircularProgressIndicator() : const Text(
                                        'Register Business'),
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
                    ),
                  ],
                ),
                const SizedBox(
                  height: 140,
                  width: 120,
                  child: Image(image: AssetImage('assets/images/200 px.png')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
