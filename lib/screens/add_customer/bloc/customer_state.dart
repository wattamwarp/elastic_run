import 'package:elastic_run/models/customer_model.dart';
import 'package:equatable/equatable.dart';


abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<Customer> customers;

  const CustomerLoaded({required this.customers});

  @override
  List<Object> get props => [customers];
}

class CustomerError extends CustomerState {
  final String message;

  const CustomerError({required this.message});

  @override
  List<Object> get props => [message];
}

