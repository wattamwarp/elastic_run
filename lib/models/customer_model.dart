class Customer {
  final int? id;
  final String customerName;

  Customer({this.id, required this.customerName});


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
