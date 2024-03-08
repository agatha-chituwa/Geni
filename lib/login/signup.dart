import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geni_app/login/verify.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Map userData = {};
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  
  get areaCode => "+265";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.addListener(() { 
      if (authProvider.verificationState == "failed") {
        _isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign up failed'),
          ),
        );
      } else if (authProvider.verificationState == "code-sent") {
        _isLoading = false;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Verify()));
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
                      //decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(40),
                      //border: Border.all(color: Colors.blueGrey)),
                      child: Image.asset('assets/images/200 px.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Enter full name'),
                      MinLengthValidator(3,
                          errorText:
                              'Name should be atleast 3 charater'),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                    controller: _name,
                    enabled: !_isLoading,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Enter email address'),
                      EmailValidator(errorText: 'Please correct email filled'),
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
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                    controller: _email,
                    enabled: !_isLoading,
                  ),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SizedBox(
                    // margin: EdgeInsets.fromLTRB(200, 20, 50, 0),

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
                        backgroundColor: const Color(0xFF19CA79), // Set the button color to green
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Adjust the radius as needed
                        ),
                      ),
                      onPressed: () {
                        debugPrint("Phone number: ${_mobile.text}");
                        if (_formkey.currentState!.validate()) {
                          _signUp();
                        }
                      },
                      child: _isLoading? const Center(child: CircularProgressIndicator(),) : const Text(
                        'sign up',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ))
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
    final result = await authProvider.signUp(
        email: _email.text,
        name: _name.text,
        mobile: "$areaCode${_mobile.text}");
    //_isLoading = false;

    // if (!context.mounted) return;

    // if (result) {
    //   Navigator.pushReplacementNamed(context, '/home');
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Sign up failed'),
    //     ),
    //   );
    // }
  }
}
