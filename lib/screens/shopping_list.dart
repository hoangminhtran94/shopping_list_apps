import 'package:flutter/material.dart';
import 'package:shopping_list_apps/models/grocery_item.dart';
import 'package:shopping_list_apps/screens/new_item.dart';
import 'package:shopping_list_apps/widgets/grocery_list.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<GroceryItem> _groceryItems = [];
  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const NewItemScreen()));
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _deleteItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Item deleted"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _groceryItems.add(item);
              });
            })));
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const Center(
      child: Text("Oops, there are no shopping list, please add one"),
    );
    if (_groceryItems.isNotEmpty) {
      body = GroceryList(
        onDelete: _deleteItem,
        groceries: _groceryItems,
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
        title: const Text(
          "Your Groceries",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: body,
    );
  }
}
