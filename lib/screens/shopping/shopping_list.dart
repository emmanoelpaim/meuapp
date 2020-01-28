import 'package:flutter/material.dart';
import 'package:meuapp/models/shopping.dart';
import 'package:meuapp/screens/shopping/shopping_tile.dart';
import 'package:provider/provider.dart';

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  @override
  Widget build(BuildContext context) {
    final shoppings = Provider.of<List<Shopping>>(context);

    return ListView.builder(
      itemCount: shoppings.length,
      itemBuilder: (context, index){
        return ShoppingTile(shopping: shoppings[index]);
      },
    );
  }
}
