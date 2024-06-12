import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/firestore.dart';
import 'dart:developer' as devtools show log;

class FirebaseAuthService extends AuthService {
  @override
  Future<bool> logIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return true;
    } catch (e) {
      devtools.log(e.toString());
    }
    
    return false;
  }

  @override
  Future<bool> register(
      String email, String password, String passwordConfirm) async {
    try {
      if (passwordConfirm == password) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.trim(), password: password.trim())
            .then((value) {
          FirestoreDataSource().createUser(email);
        });
        return true;
      }
    } catch (e) {
      devtools.log(e.toString());
    }

    return false;
  }
}
