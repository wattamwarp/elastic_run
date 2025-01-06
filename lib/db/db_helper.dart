import 'package:elastic_run/dao/customer_dao.dart';
import 'package:elastic_run/dao/inventory_dao.dart';
import 'package:elastic_run/dao/invoice_dao.dart';
import 'package:elastic_run/dao/invoice_item_dao.dart';
import 'package:elastic_run/dao/sales_return_dao.dart';
import 'package:elastic_run/dao/sales_return_item_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  final String _dbName = 'inventory.db';

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, _dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(InventoryDao.createTableQuery);
    await db.execute(CustomerDao.createTableQuery);
    await db.execute(InvoiceDao.createTableQuery);
    await db.execute(InvoiceItemDao.createTableQuery);
    await db.execute(SalesReturnDao.createTableQuery);
    await db.execute(SalesReturnItemDao.createTableQuery);

    await db.transaction((txn) async {
      final inventoryDao = InventoryDao(db);

      try {
        await inventoryDao.insertDefaultInventoryItems(txn);
      } catch (e) {
        rethrow;
      }
    });
  }

  Future<void> resetDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, _dbName);
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    await deleteDatabase(path);
    _database = await _initDatabase();
  }
}
