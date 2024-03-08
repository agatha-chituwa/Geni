import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:geni_app/ui/home_page.dart';
import 'package:provider/provider.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  bool _onEditing = true;
  String? _code;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.addListener(() {
      if (authProvider.verificationState == "failed") {
        _onEditing = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification failed'),
          ),
        );
      } else if (authProvider.verificationState == "code-sent") {
        _onEditing = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Code sent'),
          ),
        );
      } else if (authProvider.verificationState == "verified") {
        _onEditing = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Code verified'),
          ),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } else if (authProvider.verificationState == "timeout") {
        _onEditing = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification timeout'),
          ),
        );
      }
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: _isLoading? const Center(child: CircularProgressIndicator(),) : Stack(
        children: [
          Column(
            children: [
              // Logo Image

              Image.asset(
                'assets/images/200 px.png',
                height: 50.0,
                width: 50.0,
                fit: BoxFit.cover,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 70),
                child: Center(
                  child: Text(
                    'Enter your code',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              VerificationCode(
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).primaryColor),
                keyboardType: TextInputType.number,
                underlineColor: Colors.amber,
                length: 4,
                cursorColor: Colors.blue,
                clearAll: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'clear all',
                    style: TextStyle(
                        fontSize: 14.0,
                        decoration: TextDecoration.underline,
                        color: Colors.blue[700]),
                  ),
                ),
                margin: const EdgeInsets.all(12),
                onCompleted: (String value) {
                  setState(() {
                    _code = value;
                  });
                },
                onEditing: (bool value) {
                  setState(() {
                    _onEditing = value;
                  });
                  if (!_onEditing) FocusScope.of(context).unfocus();
                },
                
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: _onEditing
                      ? const Text('Please enter full code')
                      : Text('Your code: $_code'),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  _isLoading = true;
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  await authProvider.signInWithVerificationCode(_code!);
                  _isLoading = false;
                },
                child: const Text('Verify'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
