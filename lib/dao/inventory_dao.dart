import 'package:elastic_run/models/inventry_model.dart';
import 'package:sqflite/sqflite.dart';

class InventoryDao {
  final Database database;

  InventoryDao(this.database);

  Future<void> insertDefaultInventoryItems(Transaction txn) async {
    await txn.insert('Inventory',
        Inventory(quantity: 100, itemName: 'Sugar', unit: 'Bag').toMap());

    await txn.insert('Inventory',
        Inventory(quantity: 100, itemName: 'Oil', unit: 'Tin').toMap());

    await txn.insert('Inventory',
        Inventory(quantity: 100, itemName: 'Besan', unit: 'Bag').toMap());
  }

  Future<List<Inventory>> getAllInventory() async {
    final List<Map<String, dynamic>> result = await database.query('Inventory');
    return result.map((map) => Inventory.fromMap(map)).toList();
  }

  Future<int> insertInventory(Inventory inventory) async {
    return await database.insert('Inventory', inventory.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Inventory?> getInventoryByItemId(int itemId) async {
    final List<Map<String, dynamic>> result = await database.query(
      'Inventory',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
    if (result.isNotEmpty) {
      return Inventory.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateInventory(Transaction txn,Inventory inventory) async {
    return await txn.update(
      'Inventory',
      inventory.toMap(),
      where: 'item_id = ?',
      whereArgs: [inventory.itemId],
    );
  }

  Future<int> deleteInventory(int inventoryId) async {
    return await database.delete(
      'Inventory',
      where: 'inventory_id = ?',
      whereArgs: [inventoryId],
    );
  }
}
