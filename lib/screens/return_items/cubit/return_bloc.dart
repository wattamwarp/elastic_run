import 'package:elastic_run/dao/customer_dao.dart';
import 'package:elastic_run/dao/inventory_dao.dart';
import 'package:elastic_run/dao/invoice_dao.dart';
import 'package:elastic_run/dao/invoice_item_dao.dart';
import 'package:elastic_run/dao/sales_return_dao.dart';
import 'package:elastic_run/dao/sales_return_item_dao.dart';
import 'package:elastic_run/extensions/navigation.dart';
import 'package:elastic_run/extensions/snackbar.dart';
import 'package:elastic_run/main.dart';
import 'package:elastic_run/models/customer_model.dart';
import 'package:elastic_run/models/inventry_model.dart';
import 'package:elastic_run/models/invoice_item_model.dart';
import 'package:elastic_run/models/invoice_model.dart';
import 'package:elastic_run/models/sales_return.dart';
import 'package:elastic_run/models/sales_return_item.dart';
import 'package:elastic_run/screens/return_items/cubit/return_event.dart';
import 'package:elastic_run/screens/return_items/cubit/return_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReturnBloc extends Bloc<ReturnEvent, ReturnState> {
  final InventoryDao _inventoryDao = InventoryDao(database!);
  final SalesReturnDao _salesReturnDao = SalesReturnDao(database!);
  final SalesReturnItemDao _salesReturnItemDao = SalesReturnItemDao(database!);
  final InvoiceItemDao _invoiceItemDao = InvoiceItemDao(database!);
  final CustomerDao _customerDao = CustomerDao(database!);
  final InvoiceDao _invoiceDao = InvoiceDao();
  final BuildContext _context;

  ReturnBloc(this._context) : super(ReturnState(inventoryItems: [])) {
    on<LoadInventoryEvent>(_loadInventoryEvent);
    on<UpdateReturnQuantityEvent>(_updateReturnQuantityEvent);
    on<SubmitReturnEvent>(_submitReturnEvent);
  }

  void _loadInventoryEvent(
      LoadInventoryEvent event, Emitter<ReturnState> emit) async {
    try {
      final inventoryItems = await _inventoryDao.getAllInventory();
      final resetInventoryItems = inventoryItems.map((item) {
        item.quantity = 0;
        return item;
      }).toList();

      emit(state.copyWith(inventoryItems: resetInventoryItems));
    } catch (e) {
      _context.showSnackBar('Failed to load inventory: $e');
    }
  }

  void _updateReturnQuantityEvent(
      UpdateReturnQuantityEvent event, Emitter<ReturnState> emit) {
    final updatedInventoryItems = state.inventoryItems.map((item) {
      if (item.itemId == event.itemId) {
        item.quantity = event.quantity;
      }
      return item;
    }).toList();

    emit(state.copyWith(inventoryItems: updatedInventoryItems));
  }

  void _submitReturnEvent(
      SubmitReturnEvent event, Emitter<ReturnState> emit) async {
    try {
      List<Invoice> invoices = await _invoiceDao.getAllInvoices();
      List<SalesReturn> salesReturnList =
          await _processReturns(state.inventoryItems, invoices);
      await _saveSalesReturns(salesReturnList);
      _context.showSnackBar('Return processed successfully');
      _context.pop();
    } catch (e) {
      _context.showSnackBar('Error processing return: $e', duration: 10);
    }
  }

  Future<List<SalesReturn>> _processReturns(
      List<Inventory> rejectedItems, List<Invoice> invoices) async {
    List<SalesReturn> salesReturns = [];
    List<Inventory> remainingRejectedItems = [...rejectedItems];

    for (var invoice in invoices) {
      List<SalesReturnItem> returnItems = [];
      List<InvoiceItem> items =
          await _invoiceItemDao.getInvoiceItemsByInvoiceId(invoice.id ?? 1);

      for (var item in items) {
        final inventory = remainingRejectedItems.firstWhere(
            (inventory) => inventory.itemId == item.itemId,
            orElse: () =>
                Inventory(itemId: 0, itemName: '', quantity: 0, unit: ''));

        final int rejectedQuantity = inventory.quantity;

        if (rejectedQuantity > 0) {
          int returnQuantity = rejectedQuantity;

          if (returnQuantity > item.quantity) {
            returnQuantity = item.quantity;
          }

          Inventory? inventoryName =
              await _inventoryDao.getInventoryByItemId(item.itemId);
          returnItems.add(SalesReturnItem(
            itemId: item.itemId,
            itemName: inventoryName?.itemName ?? '',
            quantity: returnQuantity,
            id: 0,
            salesReturnId: 0,
          ));

          inventory.quantity -= returnQuantity;

          if (inventory.quantity == 0) {
            remainingRejectedItems.removeWhere(
                (remainingItem) => remainingItem.itemId == inventory.itemId);
          }
        }
      }

      if (returnItems.isNotEmpty) {
        Customer? customer =
            await _customerDao.getCustomerById(invoice.customerId);

        salesReturns.add(SalesReturn(
          id: 0,
          createdAt: DateTime.now(),
          customerName: customer?.customerName ?? '',
          customerId: customer?.id ?? 0,
          items: returnItems,
        ));
      }

      if (remainingRejectedItems.isEmpty) break;
    }

    return salesReturns;
  }

  Future<void> _saveSalesReturns(List<SalesReturn> salesReturns) async {
    for (var returnRecord in salesReturns) {
      final salesReturnId = await _salesReturnDao.createSalesReturn(SalesReturn(
          id: 1,
          customerId: returnRecord.customerId,
          customerName: returnRecord.customerName,
          createdAt: DateTime.now(),
          items: []));

      for (var returnItem in returnRecord.items) {
        await _salesReturnItemDao.addReturnItem(
          salesReturnId,
          returnItem,
        );
      }
      await database!.transaction((txn) async {
        for (var item in returnRecord.items) {
          await _inventoryDao.addInventoryByItemId(
              txn, item.itemId, item.quantity);
        }
      });
    }
  }
}
