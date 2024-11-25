
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ong_model.dart';

class DatabaseController {


  Future<void> storeOngData({required Ong ong}) async {

    final db = FirebaseFirestore.instance;

    await db.collection('ongData').add(
      {
        'cellNumber' : ong.cellNumber,
        'email' : ong.email,
        'isAdmin' : false,
        'isVerified' : false,
        'cep' : ong.cep,
        'city' : ong.city,
        'cnpj' : ong.cnpj,
        'description' : ong.description,
        'image' : '',
        'name' : ong.name,
        'ongCategory' : ong.ongCategory.name,
        'pixKey' : ong.pixKey,
        'projectList' : [],
        'road' : ong.road,
        'state' : ong.state,
      }
    );

  }

  Future<Map<String, dynamic>> getOngData({required String email}) async {
    final db = FirebaseFirestore.instance;

    final query = await db.collection('ongData').where('email', isEqualTo: email).get();

    return query.docs.first.data();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllOngs() async {
    final db = FirebaseFirestore.instance;

    final query = await db.collection('ongData').get();

    return query.docs;
  }

  Future<void> updateOngData({required String email, required Map<String, dynamic> newData}) async {

    final db = FirebaseFirestore.instance;

    final query = await db.collection('ongData').where('email', isEqualTo: email).get();
    
    DocumentReference documentReference = db.collection('ongData').doc(query.docs.first.id);

    await documentReference.update(newData);
  }


}