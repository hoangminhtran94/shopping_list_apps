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
  var _isLoading = true;
  String? _error;
  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const NewItemScreen()));
    if (newItem != null) {
      setState(() {
        _groceryItems.add(newItem);
      });
    }
  }

  void _loadItems() async {
    final url = Uri.https(
        "fluttershoppinglist-8dd4e-default-rtdb.asia-southeast1.firebasedatabase.app",
        "shopping-list.json");

    try {
      final response = await http.get(url);
      if (response.body != 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      if (response.statusCode >= 400) {
        setState(() {
          _error = "Failed to fetch data. Please try again later.";
        });
      }
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
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to fetch data. Please try again later.";
      });
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _deleteItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    final url = Uri.https(
        "fluttershoppinglist-8dd4e-default-rtdb.asia-southeast1.firebasedatabase.app",
        "shopping-list/${item.id}.json");
    setState(() {
      _groceryItems.remove(item);
    });
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Item deleted"),
    ));
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
    if (_isLoading) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_error != null) {
      body = Center(
        child: Text(_error!),
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
