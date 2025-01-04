import 'package:elastic_run/models/customer_model.dart';
import 'package:elastic_run/models/inventry_model.dart';
import 'package:flutter/material.dart';

abstract class SalesInvoiceState {
  final List<Inventory> inventoryItems;
  final List<Customer> customers;
  final List<TextEditingController> controllers;

  SalesInvoiceState({required this.inventoryItems, required this.controllers, required this.customers});
}

class SalesInvoiceInitial extends SalesInvoiceState {
  SalesInvoiceInitial(
      {required super.inventoryItems, required super.controllers, required super.customers});
}

class CustomerSelected extends SalesInvoiceState {
  final Customer customer;
  CustomerSelected(
      {required this.customer,
      required super.inventoryItems,
      required super.controllers, required super.customers});
}

class DataLoading extends SalesInvoiceState {
  DataLoading({required super.inventoryItems, required super.controllers, required super.customers});
}

class InventoryLoaded extends SalesInvoiceState {
  InventoryLoaded({required super.inventoryItems, required super.controllers, required super.customers});
}
