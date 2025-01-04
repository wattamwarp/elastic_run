class InvoiceItem {
  static const String tableName = 'Invoice_Items';

  final int? id;
  final int invoiceId;
  final int itemId;
  final int quantity;

  InvoiceItem({this.id, required this.invoiceId, required this.itemId, required this.quantity});

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      invoice_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
      invoice_id INTEGER NOT NULL,
      item_id INTEGER NOT NULL,
      deleted_at TEXT,
      quantity INTEGER NOT NULL,
      FOREIGN KEY (invoice_id) REFERENCES Invoices (invoice_id),
      FOREIGN KEY (item_id) REFERENCES Items (item_id)
    )
  ''';

  Map<String, dynamic> toMap() => {
    'invoice_item_id': id,
    'invoice_id': invoiceId,
    'item_id': itemId,
    'quantity': quantity,
  };

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      id: map['invoice_item_id'] as int?,
      invoiceId: map['invoice_id'] as int,
      itemId: map['item_id'] as int,
      quantity: map['quantity'] as int,
    );
  }
}
