import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geni_app/login/email_login.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:geni_app/ui/home_page.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.addListener(() {
      if (authProvider.isSignedIn && context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Welcome'),
          ),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 70.0, bottom: 70),
                  child: Center(
                    child: SizedBox(
                      width: 100,
                      height: 150,
                      child: Image.asset('assets/images/200 px.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Enter full name'),
                      MinLengthValidator(3, errorText: 'Name should be at least 3 characters'),
                    ]),
                    decoration: const InputDecoration(
                      hintText: 'Enter Full Name',
                      labelText: 'Full Name',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                    controller: _name,
                    enabled: !_isLoading,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Enter email address'),
                      EmailValidator(errorText: 'Please enter a valid email address'),
                    ]),
                    decoration: const InputDecoration(
                      hintText: 'Email Address',
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                    controller: _email,
                    enabled: !_isLoading,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Enter password'),
                      MinLengthValidator(6, errorText: 'Password should be at least 6 characters'),
                    ]),
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                    controller: _password,
                    enabled: !_isLoading,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (val) {
                      if (val != _password.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                    controller: _confirmPassword,
                    enabled: !_isLoading,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF19CA79),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _signUp();
                          }
                        },
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
                    },
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
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

  Future<void> _signUp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final result = await authProvider.signUpWithEmail(
      email: _email.text,
      name: _name.text,
      password: _password.text,
    );
    //_isLoading = false;
  }
}
