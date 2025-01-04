import 'package:elastic_run/screens/sales_data/models/supporting_models.dart';

abstract class SalesDataState {}

class SalesDataInitial extends SalesDataState {}

class SalesDataLoading extends SalesDataState {}

class SalesDataLoaded extends SalesDataState {
  final List<SalesData> salesData;

  SalesDataLoaded(this.salesData);
}

class SalesDataError extends SalesDataState {
  final String message;

  SalesDataError(this.message);
}
