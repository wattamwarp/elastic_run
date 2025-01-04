class SalesData {
  final int invoiceId;
  final String customerName;
  final List<ProductDetails> products;

  SalesData({
    required this.invoiceId,
    required this.customerName,
    required this.products,
  });
}

class ProductDetails {
  final String name;
  final int quantity;

  ProductDetails({
    required this.name,
    required this.quantity,
  });
}
