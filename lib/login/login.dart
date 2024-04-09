import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geni_app/login/VerifyLogin.dart';
import 'package:geni_app/login/signup.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _mobile = TextEditingController();
  
  get areaCode => "+265";

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.addListener(() { 
      if (authProvider.verificationState == "failed") {
        _isLoading = false;
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verification failed'),
            ),
          );
        } catch (e) {
          debugPrint("Error: $e");
        }
      } else if (authProvider.verificationState == "code-sent") {
        _isLoading = false;
        try {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VerifyLogin()));
        } catch (e) {
          debugPrint("Error: $e");
        }
        
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
            key: _formkey,
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
                      RequiredValidator(errorText: 'Please enter your phone number'),
                        PatternValidator(r'\d{9}$',
                          errorText: 'Please enter a valid phone number'),
                    ]),
                    decoration: const InputDecoration(
                      hintText: 'Phone Number', // Clear hint with area code mention
                      labelText: 'Phone',
                      prefixIcon: Icon(Icons.phone, color: Colors.grey),
                      prefixText: "+265 ", // Area code
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                    ),
                    keyboardType: TextInputType.phone, // Set keyboard type for phone number
                    controller: _mobile,
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
                )),
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
                          borderRadius: BorderRadius.circular(
                              20.0),
                        ),
                      ),
                      onPressed: () {
                        debugPrint("Phone number: ${_mobile.text}");
                        if (_formkey.currentState!.validate()) {
                          _signUp();
                        }
                      },
                      child: _isLoading? const Center(child: CircularProgressIndicator(),) : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 20,),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Register()));
                    },
                    child: const Text(
                      'Don\'t have an account? Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline, 
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    ));
  }
  
  Future<void> _signUp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final result = await authProvider.signInWithMobile(
        mobile: "$areaCode${_mobile.text}");
    //_isLoading = false;
  }
}
