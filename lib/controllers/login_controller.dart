

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/ong_model.dart';

class LoginController {

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> login({required String email, required String password}) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register({required Ong ong}) async {
  await _firebaseAuth.createUserWithEmailAndPassword(email: ong.email, password: ong.password);
  }

  Future<bool> checkIsVerified({required String email}) async {
    final db = FirebaseFirestore.instance;
    bool? isVerified = false;

    final query = await db.collection('ongData').where('email', isEqualTo: email).get();

    isVerified = query.docs.first.data()['isVerified'];

    isVerified ??= false;

    return isVerified;
  }
}