import 'package:elastic_run/models/item_model.dart';
import 'package:sqflite/sqflite.dart';

class ItemDao {
  final Database database;

  ItemDao(this.database);

  Future<int> getItemIdByCode(Transaction txn, String itemCode) async {
    final List<Map<String, dynamic>> result = await txn.query(
      'Items',
      columns: ['item_id'],
      where: 'item_code = ?',
      whereArgs: [itemCode],
    );

    if (result.isEmpty) {
      throw Exception('Item $itemCode not found in inventory.');
    }

    return result.first['item_id'] as int;
  }

  // Insert or Update Item
  Future<int> insertItem(Item item) async {
    return await database.insert('Items', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get Item by item_code
  Future<Item?> getItemByCode(String itemCode) async {
    final List<Map<String, dynamic>> result = await database.query(
      'Items',
      where: 'item_code = ?',
      whereArgs: [itemCode],
    );
    if (result.isNotEmpty) {
      return Item.fromMap(result.first);
    }
    return null;
  }

  // Get all Items
  Future<List<Item>> getAllItems() async {
    final List<Map<String, dynamic>> result = await database.query('Items');
    return result.map((map) => Item.fromMap(map)).toList();
  }

  // Delete Item
  Future<int> deleteItem(int itemId) async {
    return await database.delete(
      'Items',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
  }
}
