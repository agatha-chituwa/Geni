import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:geni_app/ui/home_page.dart';
import 'package:provider/provider.dart';

class VerifyLogin extends StatefulWidget {
  const VerifyLogin({super.key});

  @override
  State<VerifyLogin> createState() => _VerifyLoginState();
}

class _VerifyLoginState extends State<VerifyLogin> {
  bool _onEditing = true;
  bool _isLoading = false;

  String? _code;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFE9E9),
      body: SingleChildScrollView(
        child:  _isLoading? const Center(child: CircularProgressIndicator(),) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Image
            Padding(
              padding: const EdgeInsets.only(top: 85.0, bottom: 10),
              child: Center(
                child: SizedBox(
                  width: 120,
                  height: 200,
                  //decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(40),
                  //border: Border.all(color: Colors.blueGrey)),
                  child: Image.asset('assets/images/200 px.png'),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  height: 400,
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            "Please verify your account",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        // const Padding(
                        //   padding: EdgeInsets.only(top: 70),
                        //   child: Center(
                        //     child: Text(
                        //       'Enter your code',
                        //       style: TextStyle(fontSize: 20.0),
                        //     ),
                        //   ),
                        // ),
                        Center(
                          child: VerificationCode(
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                            keyboardType: TextInputType.number,
                            underlineColor: Colors.amber,
                            length: 6,
                            cursorColor: Colors.blue,
                            clearAll: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'clear all',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    decoration: TextDecoration.underline,
                                    color: Colors.red[700]),
                              ),
                            ),
                            margin: const EdgeInsets.all(1),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            "resend",
                            style: TextStyle(
                                fontSize: 14.0,
                                decoration: TextDecoration.underline,
                                color: Colors.blue[700]),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Verify Button
            Center(
              child: Container(
                margin: EdgeInsets.only(
                  bottom: 50,
                ),
                child: SizedBox(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        _isLoading = true;
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.signInWithVerificationCode(_code!);
                        _isLoading = false;
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF19CA79),
                      ),
                      child: Text("verify")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
