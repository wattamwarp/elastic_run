import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class FetchCustomersEvent extends CustomerEvent {}

class AddCustomerEvent extends CustomerEvent {
  final String name;

  const AddCustomerEvent({required this.name});

  @override
  List<Object> get props => [name];
}
