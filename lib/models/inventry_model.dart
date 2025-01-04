class Inventory {
  static const String tableName = 'Inventory';

  final int? itemId;
   int quantity;
  final String itemName;
  final String unit;

  Inventory(
      {this.itemId,
      required this.quantity,
      required this.itemName,
      required this.unit});

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      item_id INTEGER PRIMARY KEY AUTOINCREMENT,
      quantity INTEGER NOT NULL,
      item_name TEXT NOT NULL,
      unit TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (item_id) REFERENCES Items (item_id)
    )
  ''';

  Map<String, dynamic> toMap() => {
        'item_id': itemId,
        'quantity': quantity,
        'item_name': itemName,
        'unit': unit,
        'created_at': DateTime.now().toIso8601String(),
      };

  factory Inventory.fromMap(Map<String, dynamic> map) {
    return Inventory(
        itemId: map['item_id'] as int,
        quantity: map['quantity'] as int,
        itemName: map['item_name'] as String,
        unit: map['unit'] as String);
  }
}
