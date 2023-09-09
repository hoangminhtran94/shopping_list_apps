import 'package:flutter/material.dart';
import 'package:shopping_list_apps/models/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem(
      {super.key, required this.item, required this.onDelete});
  final GroceryItem item;
  final void Function(GroceryItem item) onDelete;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        onDelete(item);
      },
      key: ValueKey(item.id),
      child: ListTile(
        title: Text(item.name),
        trailing: Text(
          '${item.quantity}',
          style: const TextStyle(fontSize: 12),
        ),
        leading: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              color: item.category.color,
              borderRadius: BorderRadius.circular(3)),
        ),
      ),
    );
  }
}
