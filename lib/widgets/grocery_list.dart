import 'package:flutter/material.dart';
import "package:shopping_list_apps/data/dummy_items.dart";
import 'package:shopping_list_apps/widgets/grocery_item.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) =>
            GroceryListItem(item: groceryItems[index]));
  }
}
