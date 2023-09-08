import 'package:flutter/material.dart';
import 'package:shopping_list_apps/widgets/grocery_list.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Groceries",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: const GroceryList(),
    );
  }
}
