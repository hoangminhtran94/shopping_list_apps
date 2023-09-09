import 'package:flutter/material.dart';
import 'package:shopping_list_apps/models/grocery_item.dart';
import 'package:shopping_list_apps/widgets/grocery_item.dart';

class GroceryList extends StatelessWidget {
  const GroceryList(
      {super.key, required this.groceries, required this.onDelete});
  final List<GroceryItem> groceries;
  final void Function(GroceryItem item) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: groceries.length,
        itemBuilder: (ctx, index) => GroceryListItem(
              item: groceries[index],
              onDelete: onDelete,
            ));
  }
}
