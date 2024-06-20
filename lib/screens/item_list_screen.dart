import 'package:flutter/material.dart';
import '../utils/database_helper.dart';
import '../models/item.dart';
import '../screens/add_item_list_screen.dart';
import '../screens/edit_item_list_screen.dart';
import '../screens/item_detail_screen.dart';

class ItemListScreen extends StatefulWidget {
  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Item>> _items;

  @override
  void initState() {
    super.initState();
    _refreshItemList();
  }

  void _refreshItemList() {
    setState(() {
      _items = _dbHelper.getItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshItemList,
          ),
        ],
      ),
      body: FutureBuilder<List<Item>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found'));
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Card(
                  elevation: 3.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.inventory),
                    ),
                    title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${item.quantity}'),
                        Text('Available: ${item.isAvailable ? 'Yes' : 'No'}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _navigateToEditItemScreen(item);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _dbHelper.deleteItem(item.id!);
                            _refreshItemList();
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      _navigateToItemDetailScreen(item); 
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItemScreen(
                refreshItemList: _refreshItemList,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToEditItemScreen(Item item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditItemScreen(item)),
    );
    if (result != null && result) {
      _refreshItemList(); 
    }
  }

  void _navigateToItemDetailScreen(Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemDetailScreen(item)),
    );
  }
}
