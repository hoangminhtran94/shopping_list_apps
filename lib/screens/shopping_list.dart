import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list_apps/data/catergories.dart';
import 'package:shopping_list_apps/models/grocery_item.dart';
import 'package:shopping_list_apps/screens/new_item.dart';
import 'package:shopping_list_apps/widgets/grocery_list.dart';
import "package:http/http.dart" as http;

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<GroceryItem> _groceryItems = [];
  void _addItem() async {
    await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const NewItemScreen()));

    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        "fluttershoppinglist-8dd4e-default-rtdb.asia-southeast1.firebasedatabase.app",
        "shopping-list.json");
    final response = await http.get(url);
    final Map<String, dynamic> listData = jsonDecode(response.body);
    final List<GroceryItem> loadingItems = [];
    for (final item in listData.entries) {
      final category = categories.entries.firstWhere((category) {
        return category.value.title == item.value["category"];
      }).value;
      loadingItems.add(GroceryItem(
          id: item.key,
          name: item.value["name"],
          quantity: item.value["quantity"],
          category: category));
    }

    setState(() {
      _groceryItems = loadingItems;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
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
