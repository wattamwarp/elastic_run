class Customer {
  static const String tableName = 'Customers';

  final int? id;
  final String customerName;

  Customer({this.id, required this.customerName});

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_name TEXT NOT NULL
    )
  ''';

  Map<String, dynamic> toMap() => {
    'customer_id': id,
    'customer_name': customerName,
  };

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['customer_id'] as int?,
      customerName: map['customer_name'] as String,
    );
  }
}
