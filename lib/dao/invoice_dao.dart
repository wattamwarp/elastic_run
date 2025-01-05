import 'package:elastic_run/db/db_helper.dart';
import 'package:elastic_run/main.dart';
import 'package:elastic_run/models/invoice_model.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceDao {

  static const String tableName = 'Invoices';

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      invoice_id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_id INTEGER NOT NULL,
      invoice_type TEXT CHECK(invoice_type IN ('Sales Invoice', 'Sales Return')) NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (customer_id) REFERENCES Customers (customer_id)
    )
  ''';

  Future<List<Invoice>> getAllInvoices() async {
    final List<Map<String, dynamic>> result = await database!.query('Invoices');
    return result.map((map) => Invoice.fromMap(map)).toList();
  }

  Future<int> insertInvoice(Transaction txn, Invoice invoice) async {
    final invoiceId = await txn.insert(
      'Invoices',
      invoice.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return invoiceId;
  }
}
