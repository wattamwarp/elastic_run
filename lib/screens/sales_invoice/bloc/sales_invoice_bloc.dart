import 'package:elastic_run/dao/customer_dao.dart';
import 'package:elastic_run/dao/inventory_dao.dart';
import 'package:elastic_run/dao/invoice_dao.dart';
import 'package:elastic_run/dao/invoice_item_dao.dart';
import 'package:elastic_run/db/db_helper.dart';
import 'package:elastic_run/extensions/navigation.dart';
import 'package:elastic_run/extensions/snackbar.dart';
import 'package:elastic_run/main.dart';
import 'package:elastic_run/models/customer_model.dart';
import 'package:elastic_run/models/inventry_model.dart';
import 'package:elastic_run/models/invoice_item_model.dart';
import 'package:elastic_run/models/invoice_model.dart';
import 'package:elastic_run/screens/sales_invoice/bloc/sales_invoice_event.dart';
import 'package:elastic_run/screens/sales_invoice/bloc/sales_invoice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class SalesInvoiceBloc extends Bloc<SalesInvoiceEvent, SalesInvoiceState> {
  /// this objects can be simplified by GetIt and app instance architecture
  /// due to time constrains not able to do
  final CustomerDao _customerDao = CustomerDao(database!);
  final InventoryDao _inventoryDao = InventoryDao(database!);
  final InvoiceDao _invoiceDao = InvoiceDao();
  final InvoiceItemDao _invoiceItemDao = InvoiceItemDao(database!);
  final List<Customer> _selectedCustomer = [];

  SalesInvoiceBloc()
      : super(SalesInvoiceInitial(
            inventoryItems: [], controllers: [], customers: [])) {
    _registerEventHandlers();
  }

  void _registerEventHandlers() {
    on<SelectCustomerEvent>(_onCustomerSelected);
    on<FetchInventoryEvent>(_fetchInventory);
    on<CreateInvoiceEvent>(_onCreateInvoice);
  }

  void _onCreateInvoice(
      CreateInvoiceEvent event, Emitter<SalesInvoiceState> emit) async {
    Database db = await DatabaseHelper().database;
    if (_selectedCustomer.isEmpty) {
      event.context.showSnackBar('Add customers / select customer name');
      return;
    }
    try {
      await db.transaction((txn) async {
        int invoiceId = await _createInvoice(txn, _selectedCustomer.first.id);
        _validateQuantities(state.inventoryItems, state.controllers);
        await _processInventoryItems(
            txn, invoiceId, state.inventoryItems, state.controllers);
      });
      event.context.pop();
    } catch (e) {
      event.context.showSnackBar(e.toString());
    }
  }

  Future<int> _createInvoice(Transaction txn, int? customerId) async {
    return await _invoiceDao.insertInvoice(
      txn,
      Invoice(
        customerId: customerId ?? 0,
        invoiceType: 'Sales Invoice',
        createdAt: DateTime.now(),
      ),
    );
  }

  void _validateQuantities(
    List<Inventory> inventoryItems,
    List<TextEditingController> controllers,
  ) {
    for (int i = 0; i < inventoryItems.length; i++) {
      Inventory inventory = inventoryItems[i];
      final int quantityToSell = int.tryParse(controllers[i].text) ?? 0;

      if (quantityToSell <= -1 || quantityToSell > inventory.quantity) {
        throw Exception(
          'Invalid quantity for item: ${inventory.itemName}. Enter a quantity between 1 and ${inventory.quantity}.',
        );
      }
    }
  }

  Future<void> _processInventoryItems(
    Transaction txn,
    int invoiceId,
    List<Inventory> inventoryItems,
    List<TextEditingController> controllers,
  ) async {
    for (int i = 0; i < inventoryItems.length; i++) {
      Inventory inventory = inventoryItems[i];
      final int quantityToSell = int.tryParse(controllers[i].text) ?? 0;
      if (quantityToSell > 0) {
        await _invoiceItemDao.insertInvoiceItem(
          txn,
          InvoiceItem(
            invoiceId: invoiceId,
            itemId: inventory.itemId ?? 0,
            quantity: quantityToSell,
          ),
        );

        inventory.quantity -= quantityToSell;
        await _inventoryDao.updateInventory(txn, inventory);
      }
    }
  }

  Future<void> _onCustomerSelected(
      SelectCustomerEvent event, Emitter<SalesInvoiceState> emit) async {
    _selectedCustomer.clear();
    _selectedCustomer.add(event.customer);
    emit(CustomerSelected(
      customer: event.customer,
      inventoryItems: state.inventoryItems,
      controllers: state.controllers,
      customers: state.customers,
    ));
  }

  Future<void> _fetchInventory(
      FetchInventoryEvent event, Emitter<SalesInvoiceState> emit) async {
    emit(DataLoading(inventoryItems: [], controllers: [], customers: []));

    final customers = await _customerDao.getAllCustomers();
    final inventory = await _inventoryDao.getAllInventory();
    final controllers = _createControllers(inventory.length);

    emit(InventoryLoaded(
      inventoryItems: inventory,
      controllers: controllers,
      customers: customers,
    ));
  }

  List<TextEditingController> _createControllers(int count) {
    return List.generate(count, (_) => TextEditingController());
  }
}
