import 'package:elastic_run/models/inventry_model.dart';

class ReturnState {
  final List<Inventory> inventoryItems;

  ReturnState({
    required this.inventoryItems,
  });

  ReturnState copyWith({
    List<Inventory>? inventoryItems,
  }) {
    return ReturnState(
      inventoryItems: inventoryItems ?? this.inventoryItems,
    );
  }
}