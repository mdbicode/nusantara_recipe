import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nusantara_recipe/collection.dart';
export 'package:firebase_auth/firebase_auth.dart';

class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async{
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password,
      );
  }
  Future<void> createUserWithEmailAndPassword({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async{
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
    email: email, 
    password: password,
  );

    String userId = userCredential.user!.uid;
    
    await _users.doc(userId).set({
    'name': name,
    'phone': phone,
    'email': email,
  });
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
  DocumentSnapshot doc = await _users.doc(userId).get();
  return doc.data() as Map<String, dynamic>?;
}

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
