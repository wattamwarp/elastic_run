class ReturnEvent {}

class LoadInventoryEvent extends ReturnEvent {}

class UpdateReturnQuantityEvent extends ReturnEvent {
  final int itemId;
  final int quantity;

  UpdateReturnQuantityEvent({required this.itemId, required this.quantity});
}

class SubmitReturnEvent extends ReturnEvent {
}