import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth{
  Future<FirebaseUser> currentUser();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String email, String password);
  Future<void> signOut();
  Future<String> getEmail();
}

class Auth implements BaseAuth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> createUser(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    print("uid ${user.uid}");
    return user;
  }

  Future<String> getEmail() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.email;
  }
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}