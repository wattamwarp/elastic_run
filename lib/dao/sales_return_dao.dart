import 'package:elastic_run/models/sales_return.dart';
import 'package:sqflite/sqflite.dart';

class SalesReturnDao {

  final Database database;

  SalesReturnDao(this.database);

  static const String tableName = 'sales_returns';

  static String createTableQuery = '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_id INTEGER NOT NULL,
      customer_name TEXT NOT NULL,
      created_at TEXT NOT NULL
    );
  ''';

  Future<int> createSalesReturn(SalesReturn salesReturn) async {
    final salesReturnId =
        await database.insert('sales_returns', salesReturn.toMap());
    return salesReturnId;
  }

  Future<List<SalesReturn>> getAllSalesReturns() async {
    final result = await database.query(tableName);
    return result.map((map) => SalesReturn.fromMap(map)).toList();
  }
}
