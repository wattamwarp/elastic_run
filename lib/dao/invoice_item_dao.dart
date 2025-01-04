import 'package:elastic_run/models/invoice_item_model.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceItemDao {
  final Database database;

  InvoiceItemDao(this.database);

  Future<InvoiceItem> getInvoiceItemByInvoiceIdAndItemId(
      Transaction txn, int invoiceId, int itemId) async {
    final List<Map<String, dynamic>> result = await txn.query(
      InvoiceItem.tableName,
      where: 'invoice_id = ? AND item_id = ?',
      whereArgs: [invoiceId, itemId],
    );

    if (result.isEmpty) {
      throw Exception(
          'InvoiceItem not found for invoiceId $invoiceId and itemId $itemId');
    }

    return InvoiceItem.fromMap(result.first);
  }

  Future<int> getTotalSoldQuantityForItem(Transaction txn, int itemId) async {
    final List<Map<String, dynamic>> result = await txn.rawQuery('''
      SELECT SUM(ii.quantity) AS total_sold
      FROM Invoice_Items ii
      JOIN Invoices i ON ii.invoice_id = i.invoice_id
      WHERE ii.item_id = ? AND i.invoice_type = 'Sales Invoice'
    ''', [itemId]);

    return (result.first['total_sold'] as int?) ?? 0;
  }

  Future<void> addReturnItem(
      Transaction txn, int salesReturnId, int itemId, int quantity) async {
    final Map<String, dynamic> data = {
      'invoice_id': salesReturnId,
      'item_id': itemId,
      'quantity': quantity,
    };
    await txn.insert('Invoice_Items', data);
  }

  Future<void> softDeleteInvoiceItem(Transaction txn, int invoiceItemId) async {
    await txn.update(
      'Invoice_Items',
      {'deleted_at': DateTime.now().toIso8601String()},
      where: 'invoice_item_id = ?',
      whereArgs: [invoiceItemId],
    );
  }

  // Insert or Update Invoice Item
  Future<int> insertInvoiceItem(
      Transaction txn, InvoiceItem invoiceItem) async {
    return await txn.insert('Invoice_Items', invoiceItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get invoice item by invoice_item_id
  Future<InvoiceItem?> getInvoiceItemById(int invoiceItemId) async {
    final List<Map<String, dynamic>> result = await database.query(
      'Invoice_Items',
      where: 'invoice_item_id = ?',
      whereArgs: [invoiceItemId],
    );
    if (result.isNotEmpty) {
      return InvoiceItem.fromMap(result.first);
    }
    return null;
  }

  // Get all Invoice Items by invoice_id
  Future<List<InvoiceItem>> getInvoiceItemsByInvoiceId(int invoiceId) async {
    final List<Map<String, dynamic>> result = await database.query(
      'Invoice_Items',
      where: 'invoice_id = ?',
      whereArgs: [invoiceId],
    );
    return result.map((map) => InvoiceItem.fromMap(map)).toList();
  }

  // Delete Invoice Item
  Future<int> deleteInvoiceItem(int invoiceItemId) async {
    return await database.delete(
      'Invoice_Items',
      where: 'invoice_item_id = ?',
      whereArgs: [invoiceItemId],
    );
  }
}
