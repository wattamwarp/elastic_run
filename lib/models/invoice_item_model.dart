class InvoiceItem {


  final int? id;
  final int invoiceId;
  final int itemId;
  final int quantity;

  InvoiceItem({this.id, required this.invoiceId, required this.itemId, required this.quantity});


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
