import 'package:elastic_run/models/sales_return_item.dart';
import 'package:sqflite/sqlite_api.dart';

class SalesReturnItemDao {
  final Database db;

  SalesReturnItemDao(this.db);

  static const String tableName = 'sales_return_items';

  static String createTableQuery = '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      sales_return_id INTEGER NOT NULL,
      item_id INTEGER NOT NULL,
      item_name TEXT NOT NULL ,
      quantity INTEGER NOT NULL,
      FOREIGN KEY (sales_return_id) REFERENCES sales_returns (id) ON DELETE CASCADE
    );
  ''';

  Future<void> addReturnItem(int salesReturnId, SalesReturnItem item) async {
    await db.insert('sales_return_items', {
      'sales_return_id': salesReturnId,
      'item_id': item.itemId,
      'item_name': item.itemName,
      'quantity': item.quantity,
    });
  }

  Future<List<SalesReturnItem>> getSalesReturnItemsByReturnId(
      int salesReturnId) async {
    final result = await db.query(
      tableName,
      where: 'sales_return_id = ?',
      whereArgs: [salesReturnId],
    );
    return result.map((map) => SalesReturnItem.fromMap(map)).toList();
  }
}
