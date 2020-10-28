import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  
  Stream<String> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map((FirebaseUser user) => user?.uid);
  }

  
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user.uid;
    
  }

 
  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    return (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user.uid;
    // return authResult.user.uid;
  }

  
  Future<String> current() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

    Future<String> currentUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
