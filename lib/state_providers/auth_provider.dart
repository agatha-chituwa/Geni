
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/model/user_model.dart' as user_model;
import 'package:geni_app/repositories/user_repository.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuth _firebaseAuth;
  // Flag to indicate if user is signed in
  bool _isSignedIn = false;

  // User object after successful sign-in
  User? _currentUser;
  
  String _email = "";
  String _name = "";

  // Stream to listen to authentication state changes
  Stream<User?> get userStream => _firebaseAuth.authStateChanges();

  // Check if user is signed in
  bool get isSignedIn => _isSignedIn;

  // Get current user object
  User? get currentUser => _currentUser;

  // Phone number verification code
  String? _verificationCode;

  // Phone number entered by the user
  String? _phoneNumber;

  // initialize the provider
  initialize() {
    _firebaseAuth = FirebaseAuth.instance;
    _currentUser = _firebaseAuth.currentUser;
    debugPrint("Current user: $_currentUser");
    _isSignedIn = _currentUser != null;
    _firebaseAuth.authStateChanges().listen((User? user) {
      _isSignedIn = user != null;
      _currentUser = user;
      notifyListeners();
    });
  }

  String verificationState = "";

  // Start phone number verification process
  Future<void> startPhoneVerification(String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint("Phone number verification failed: $e");
          verificationState = "failed";
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationCode = verificationId;
          debugPrint("Verification code sent to $phoneNumber");
          verificationState = "code-sent";
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationCode = verificationId;
          debugPrint("Auto retrieval timeout");
          verificationState = "timeout";
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint("Error starting phone number verification: $e");
    }
  }

  // Sign in with verification code
  Future<void> signInWithVerificationCode(String code) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationCode!,
        smsCode: code,
      );
      await _signInWithCredential(credential);
    } catch (e) {
      debugPrint("Sign in with verification code failed: $e");
    }
  }

  // Sign in with provided credential
  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      _currentUser = userCredential.user;
      _isSignedIn = true;

      await _checkUser();

      verificationState = "verified";

      notifyListeners();
    } catch (e) {
      debugPrint("Sign in with credential failed: $e");
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    _currentUser = null;
    notifyListeners();
  }

  signUp({required String email, required String name, required String mobile}) async {
  try {
     _phoneNumber = mobile;
      _email = email;
      _name = name;
     return await startPhoneVerification(mobile);

  } on FirebaseAuthException catch (e) {
    debugPrint("Firebase sign up error: $e");
    return false;
  } catch (e) {
    debugPrint("Unexpected sign up error: $e");
    return false;
  }
}

  _checkUser() async {
    if (!(await DataModel().usersCollection.doc(_phoneNumber).get()).exists) {
      final mUser = user_model.User(
      name: _name,
      email: _email,
      phone: _phoneNumber!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    debugPrint("User: ${_firebaseAuth.currentUser}");
    await UserRepository().addUser(mUser);
      return true;
    } else {
      return true;
    }
  }

  signIn({required String mobile}) {
    _phoneNumber = mobile;
    return startPhoneVerification(mobile);
  }

}
