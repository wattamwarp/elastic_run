import 'package:elastic_run/models/rejected_item_model.dart';
import 'package:sqflite/sqflite.dart';

class RejectedItemDao {
  final Database database;

  RejectedItemDao(this.database);

  // Insert or Update Rejected Item
  Future<int> insertRejectedItem(RejectedItem rejectedItem) async {
    return await database.insert(
      'Rejected_Items',
      rejectedItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get rejected item by rejected_item_id
  Future<RejectedItem?> getRejectedItemById(int rejectedItemId) async {
    final List<Map<String, dynamic>> result = await database.query(
      'Rejected_Items',
      where: 'rejected_item_id = ?',
      whereArgs: [rejectedItemId],
    );
    if (result.isNotEmpty) {
      return RejectedItem.fromMap(result.first);
    }
    return null;
  }

  // Get all Rejected Items
  Future<List<RejectedItem>> getAllRejectedItems() async {
    final List<Map<String, dynamic>> result = await database.query('Rejected_Items');
    return result.map((map) => RejectedItem.fromMap(map)).toList();
  }

  // Delete Rejected Item
  Future<int> deleteRejectedItem(int rejectedItemId) async {
    return await database.delete(
      'Rejected_Items',
      where: 'rejected_item_id = ?',
      whereArgs: [rejectedItemId],
    );
  }
}
