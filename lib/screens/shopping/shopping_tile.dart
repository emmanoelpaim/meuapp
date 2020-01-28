import 'package:flutter/material.dart';
import 'package:meuapp/models/shopping.dart';

class ShoppingTile extends StatelessWidget {
  final Shopping shopping;

  ShoppingTile({this.shopping});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 8.0,
      ),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.00, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.indigo[100],
          ),
          title: Text(shopping.name),
          subtitle: Text('Informações'),
        ),
      ),
    );
  }
}
