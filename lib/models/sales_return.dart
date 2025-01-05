import 'package:elastic_run/models/sales_return_item.dart';

class SalesReturn {
  final int id;
  final int customerId;
  final String customerName;
  final DateTime createdAt;
  final List<SalesReturnItem> items;

  SalesReturn({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.createdAt,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'customer_name': customerName,
      'customer_id': customerId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SalesReturn.fromMap(Map<String, dynamic> map) {
    return SalesReturn(
      id: map['id'],
      customerName: map['customer_name'],
      customerId: map['customer_id'],
      createdAt: DateTime.parse(map['created_at']),
      items: [],
    );
  }
}
