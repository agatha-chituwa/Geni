import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geni_app/login/reset_password_page.dart';
import 'package:geni_app/login/signup.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:geni_app/ui/home_page.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  bool _error = false;
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.addListener(() {
      if (authProvider.isSignedIn && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Welcome'),
          ),
        );

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formkey,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth > 600 ? 400 : constraints.maxWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: constraints.maxHeight * 0.1,
                        ),
                        Center(
                          child: SizedBox(
                            width: 100,
                            height: 150,
                            child: Image.asset('assets/images/200 px.png'),
                          ),
                        ),
                        if (_error)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Sign in failed. Please check your credentials.',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: EmailValidator(
                                errorText: 'Please enter a valid email address'),
                            decoration: const InputDecoration(
                              hintText: 'Email Address',
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              ),
                            ),
                            controller: _emailController,
                            enabled: !_isLoading,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: RequiredValidator(
                                errorText: 'Please enter your password'),
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              ),
                            ),
                            controller: _passwordController,
                            enabled: !_isLoading,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SizedBox(
                              width: constraints.maxWidth > 600 ? 400 : constraints.maxWidth * 0.8,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF19CA79),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formkey.currentState!.validate()) {
                                    _signIn();
                                  }
                                },
                                child: _isLoading
                                    ? const Center(child: CircularProgressIndicator())
                                    : const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()));
                            },
                            child: const Text(
                              'Don\'t have an account? Sign Up',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const ResetPasswordPage()));
                            },
                            child: const Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _signIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final result = await authProvider.signInWithEmail(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!result) {
      setState(() {
        _error = true;
        _isLoading = false;
      });
    }
  }
}
