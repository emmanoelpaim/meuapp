import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // collection reference user
  final CollectionReference userCollection =
      Firestore.instance.collection('user');

  Future updateUserData(String name) async {
    return await userCollection.document(uid).setData({'name': name});
  }


  // collection reference shopping
  final CollectionReference shoppingCollection =
  Firestore.instance.collection('shopping');


  Stream<QuerySnapshot> get shoppings{
    return shoppingCollection.snapshots();
  }

}
