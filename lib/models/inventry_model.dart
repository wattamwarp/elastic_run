class Inventory {


  final int? itemId;
  final String itemName;
  final String unit;
  int quantity;

  Inventory(
      {this.itemId,
      required this.quantity,
      required this.itemName,
      required this.unit});


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
