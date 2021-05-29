import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {

  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);

  Future<String> SignIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch(e){

    }
  }

}