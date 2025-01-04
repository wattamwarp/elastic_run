// Events
import 'package:elastic_run/models/customer_model.dart';
import 'package:flutter/cupertino.dart';

abstract class SalesInvoiceEvent {}

class SelectCustomerEvent extends SalesInvoiceEvent {
  final Customer customer;

  SelectCustomerEvent({required this.customer});
}

class FetchInventoryEvent extends SalesInvoiceEvent {}

class CreateInvoiceEvent extends SalesInvoiceEvent {
final BuildContext context;

  CreateInvoiceEvent({ required this.context});
}
