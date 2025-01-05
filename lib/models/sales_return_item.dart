class SalesReturnItem {
  final int id;
  final int salesReturnId;
  final int itemId;
  final String itemName;
  final int quantity;

  SalesReturnItem({
    required this.id,
    required this.salesReturnId,
    required this.itemId,
    required this.itemName,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'sales_return_id': salesReturnId,
      'item_id': itemId,
      'item_name': itemName,
      'quantity': quantity,
    };
  }

  factory SalesReturnItem.fromMap(Map<String, dynamic> map) {
    return SalesReturnItem(
      id: map['id']??1,
      salesReturnId: map['sales_return_id']??1,
      itemId: map['item_id']??1,
      itemName: map['item_name']??'',
      quantity: map['quantity']??0,
    );
  }
}
