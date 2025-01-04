import 'package:elastic_run/dao/customer_dao.dart';
import 'package:elastic_run/main.dart';
import 'package:elastic_run/models/customer_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerDao _customerDao = CustomerDao(database!);

  CustomerBloc() : super(CustomerLoading()) {
    on<FetchCustomersEvent>(_onFetchCustomers);
    on<AddCustomerEvent>(_onAddCustomer);
  }

  Future<void> _onFetchCustomers(
      FetchCustomersEvent event, Emitter<CustomerState> emit) async {
    try {
      emit(CustomerLoading());

      final customers = await _customerDao.getAllCustomers();
      emit(CustomerLoaded(customers: customers));
    } catch (e) {
      emit(CustomerError(message: e.toString()));
    }
  }

  Future<void> _onAddCustomer(
      AddCustomerEvent event, Emitter<CustomerState> emit) async {
    try {
      await _customerDao.insertCustomer(Customer(customerName: event.name));
      add(FetchCustomersEvent());
    } catch (e) {
      emit(CustomerError(message: e.toString()));
    }
  }
}
