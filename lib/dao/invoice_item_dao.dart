import 'package:elastic_run/models/invoice_item_model.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceItemDao {
  final Database database;

  static const String tableName = 'Invoice_Items';

  InvoiceItemDao(this.database);

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      invoice_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
      invoice_id INTEGER NOT NULL,
      item_id INTEGER NOT NULL,
      deleted_at TEXT,
      quantity INTEGER NOT NULL,
      FOREIGN KEY (invoice_id) REFERENCES Invoices (invoice_id),
      FOREIGN KEY (item_id) REFERENCES Items (item_id)
    )
  ''';

  Future<int> insertInvoiceItem(
      Transaction txn, InvoiceItem invoiceItem) async {
    return await txn.insert(tableName, invoiceItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<InvoiceItem>> getInvoiceItemsByInvoiceId(int invoiceId) async {
    final List<Map<String, dynamic>> result = await database.query(
      tableName,
      where: 'invoice_id = ?',
      whereArgs: [invoiceId],
    );
    return result.map((map) => InvoiceItem.fromMap(map)).toList();
  }
}
