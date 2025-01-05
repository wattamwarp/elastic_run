import 'package:elastic_run/models/customer_model.dart';
import 'package:sqflite/sqlite_api.dart';

class CustomerDao {
  final Database database;

  static const String tableName = 'Customers';
  CustomerDao(this.database);

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_name TEXT NOT NULL
    )
  ''';

  Future<int> insertCustomer(Customer customer) async {
    return await database.insert('Customers', customer.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Customer?> getCustomerById(int customerId) async {
    final List<Map<String, dynamic>> result = await database.query(
      'Customers',
      where: 'customer_id = ?',
      whereArgs: [customerId],
    );
    if (result.isNotEmpty) {
      return Customer.fromMap(result.first);
    }
    return null;
  }

  Future<List<Customer>> getAllCustomers() async {
    final List<Map<String, dynamic>> result = await database.query('Customers');
    return result.map((map) => Customer.fromMap(map)).toList();
  }

}
