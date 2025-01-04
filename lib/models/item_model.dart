class Item {
  static const String tableName = 'Items';

  final int? id;
  final String itemCode;
  final String itemName;
  final String unit;

  Item(
      {this.id,
      required this.itemCode,
      required this.itemName,
      required this.unit});

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      item_id INTEGER PRIMARY KEY AUTOINCREMENT,
      item_code TEXT UNIQUE NOT NULL,
      item_name TEXT NOT NULL,
      unit TEXT NOT NULL
    )
  ''';

  Map<String, dynamic> toMap() => {
        'item_id': id,
        'item_code': itemCode,
        'item_name': itemName,
        'unit': unit,
      };

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['item_id'] as int?,
      itemCode: map['item_code'] as String,
      itemName: map['item_name'] as String,
      unit: map['unit'] as String,
    );
  }
}
