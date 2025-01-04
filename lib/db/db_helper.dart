import 'package:elastic_run/dao/inventory_dao.dart';
import 'package:elastic_run/models/customer_model.dart';
import 'package:elastic_run/models/inventry_model.dart';
import 'package:elastic_run/models/invoice_item_model.dart';
import 'package:elastic_run/models/invoice_model.dart';
import 'package:elastic_run/models/item_model.dart';
import 'package:elastic_run/models/rejected_item_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'inventory.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(Item.createTableQuery);
    await db.execute(Inventory.createTableQuery);
    await db.execute(Customer.createTableQuery);
    await db.execute(Invoice.createTableQuery);
    await db.execute(InvoiceItem.createTableQuery);
    await db.execute(RejectedItem.createTableQuery);

    await db.transaction((txn) async {
      final inventoryDao = InventoryDao(db);

      try {
        await inventoryDao.insertDefaultInventoryItems(txn);
      } catch (e) {
        rethrow;
      }
    });
  }
}
