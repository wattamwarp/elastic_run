import 'package:elastic_run/models/invoice_model.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceDao {
  final Database database;

  InvoiceDao(this.database);

  Future<List<Invoice>> getAllInvoices() async {
    final List<Map<String, dynamic>> result = await database.query('Invoices');
    return result.map((map) => Invoice.fromMap(map)).toList();
  }

  Future<List<Invoice>> getInvoicesForItem(Transaction txn, int itemId) async {
    final List<Map<String, dynamic>> result = await txn.query(
      'Invoice_Items ii',
      columns: [
        'ii.invoice_item_id',
        'ii.invoice_id',
        'ii.quantity',
        'i.customer_id',
        'i.invoice_type',
        'i.created_at'
      ],
      where: 'ii.item_id = ? AND i.invoice_type = "Sales Invoice"',
      whereArgs: [itemId],
      orderBy: 'i.created_at ASC',
    );

    return result.map((row) {
      return Invoice.fromMap({
        'invoice_id': row['invoice_id'],
        'customer_id': row['customer_id'],
        'invoice_type': row['invoice_type'],
        'created_at': row['created_at'],
      });
    }).toList();
  }

  Future<int> createSalesReturnInvoice(Transaction txn, int customerId) async {
    final Map<String, dynamic> data = {
      'customer_id': customerId,
      'invoice_type': 'Sales Return',
      'created_at': DateTime.now().toIso8601String(),
    };
    return await txn.insert('Invoices', data);
  }

  Future<int> insertInvoice(Transaction txn, Invoice invoice) async {
    final invoiceId = await txn.insert(
      'Invoices',
      invoice.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return invoiceId;
  }

  Future<Invoice?> getInvoiceById(int invoiceId) async {
    final List<Map<String, dynamic>> result = await database.query(
      'Invoices',
      where: 'invoice_id = ?',
      whereArgs: [invoiceId],
    );
    if (result.isNotEmpty) {
      return Invoice.fromMap(result.first);
    }
    return null;
  }

  // Get all Invoices for a customer
  Future<List<Invoice>> getInvoicesByCustomer(int customerId) async {
    final List<Map<String, dynamic>> result = await database.query(
      'Invoices',
      where: 'customer_id = ?',
      whereArgs: [customerId],
    );
    return result.map((map) => Invoice.fromMap(map)).toList();
  }

  // Delete Invoice
  Future<int> deleteInvoice(int invoiceId) async {
    return await database.delete(
      'Invoices',
      where: 'invoice_id = ?',
      whereArgs: [invoiceId],
    );
  }
}
