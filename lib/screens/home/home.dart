import 'package:flutter/material.dart';
import 'package:meuapp/models/shopping.dart';
import 'file:///C:/Users/emmanoel/FlutterProjects/meuapp/meuapp/lib/screens/shopping/shopping_list.dart';
import 'package:meuapp/services/auth.dart';
import 'package:meuapp/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Shopping>>.value(
      value: DatabaseService().shoppings,
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        appBar: AppBar(
          title: Text('Meu app'),
          backgroundColor: Colors.indigo[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            )
          ],
        ),
        body: ShoppingList(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
          },
          label: Text('Approve'),
          icon: Icon(Icons.thumb_up),
          backgroundColor: Colors.pink,
        ),
      ),
    );
  }
}
