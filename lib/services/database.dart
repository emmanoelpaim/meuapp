import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meuapp/models/shopping.dart';

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


  // get shopping list snapshot
  List<Shopping> _shoppingListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) {
      return Shopping(
        name: doc.data['name'] ?? '',
        date: doc.data['date'] ?? ''
      );
    }).toList();
  }

  // get shopping stream
  Stream<List<Shopping>> get shoppings{
    return shoppingCollection.snapshots().map(_shoppingListFromSnapshot);
  }

}
