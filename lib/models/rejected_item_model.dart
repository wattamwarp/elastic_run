class RejectedItem {
  static const String tableName = 'Rejected_Items';

  final int? id;
  final int itemId;
  final int quantity;
  final bool processed;

  RejectedItem({this.id, required this.itemId, required this.quantity, this.processed = false});

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      rejected_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
      item_id INTEGER NOT NULL,
      quantity INTEGER NOT NULL,
      processed BOOLEAN DEFAULT FALSE,
      FOREIGN KEY (item_id) REFERENCES Items (item_id)
    )
  ''';

  Map<String, dynamic> toMap() => {
    'rejected_item_id': id,
    'item_id': itemId,
    'quantity': quantity,
    'processed': processed ? 1 : 0,
  };

  factory RejectedItem.fromMap(Map<String, dynamic> map) {
    return RejectedItem(
      id: map['rejected_item_id'] as int?,
      itemId: map['item_id'] as int,
      quantity: map['quantity'] as int,
      processed: map['processed'] == 1,
    );
  }
}
