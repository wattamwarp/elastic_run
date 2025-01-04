class Invoice {
  static const String tableName = 'Invoices';

  final int? id;
  final int customerId;
  final String invoiceType;
  final DateTime createdAt;

  Invoice({this.id, required this.customerId, required this.invoiceType, required this.createdAt});

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      invoice_id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_id INTEGER NOT NULL,
      invoice_type TEXT CHECK(invoice_type IN ('Sales Invoice', 'Sales Return')) NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (customer_id) REFERENCES Customers (customer_id)
    )
  ''';

  Map<String, dynamic> toMap() => {
    'invoice_id': id,
    'customer_id': customerId,
    'invoice_type': invoiceType,
    'created_at': createdAt.toIso8601String(),
  };

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['invoice_id'] as int?,
      customerId: map['customer_id'] as int,
      invoiceType: map['invoice_type'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
