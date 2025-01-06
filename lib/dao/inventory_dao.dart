import 'package:elastic_run/models/inventry_model.dart';
import 'package:sqflite/sqflite.dart';

class InventoryDao {
  final Database database;

  InventoryDao(this.database);

  static const String tableName = 'Inventory';
  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      item_id INTEGER PRIMARY KEY AUTOINCREMENT,
      quantity INTEGER NOT NULL,
      item_name TEXT NOT NULL,
      unit TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (item_id) REFERENCES Items (item_id)
    )
  ''';

  Future<void> insertDefaultInventoryItems(Transaction txn) async {
    await txn.insert(tableName,
        Inventory(quantity: 100, itemName: 'Sugar', unit: 'Bag').toMap());

    await txn.insert(tableName,
        Inventory(quantity: 50, itemName: 'Oil', unit: 'Tin').toMap());

    await txn.insert(tableName,
        Inventory(quantity: 40, itemName: 'Besan', unit: 'Bag').toMap());
  }

  Future<List<Inventory>> getAllInventory() async {
    final List<Map<String, dynamic>> result = await database.query('Inventory');
    return result.map((map) => Inventory.fromMap(map)).toList();
  }

  Future<int> insertInventory(Inventory inventory) async {
    return await database.insert(tableName, inventory.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Inventory?> getInventoryByItemId(int itemId) async {
    final List<Map<String, dynamic>> result = await database.query(
      tableName,
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
    if (result.isNotEmpty) {
      return Inventory.fromMap(result.first);
    }
    return null;
  }

  Future<int> addInventoryByItemId(
      Transaction txn, int itemId, int quantity) async {
    return await txn.rawUpdate(
      '''
    UPDATE $tableName
    SET quantity = quantity + ?
    WHERE item_id = ?
    ''',
      [quantity, itemId],
    );
  }

  Future<int> updateInventory(Transaction txn,Inventory inventory) async {
    return await txn.update(
      tableName,
      inventory.toMap(),
      where: 'item_id = ?',
      whereArgs: [inventory.itemId],
    );
  }

}
