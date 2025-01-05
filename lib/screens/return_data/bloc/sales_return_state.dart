import 'package:elastic_run/models/sales_return.dart';

abstract class SalesReturnState {}

class SalesReturnInitial extends SalesReturnState {}

class SalesReturnLoaded extends SalesReturnState {
  final List<SalesReturn> salesReturns;

  SalesReturnLoaded({required this.salesReturns});
}

class SalesReturnError extends SalesReturnState {
  final String error;

  SalesReturnError({required this.error});
}
