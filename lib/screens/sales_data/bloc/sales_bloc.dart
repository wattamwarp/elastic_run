import 'package:elastic_run/dao/customer_dao.dart';
import 'package:elastic_run/dao/inventory_dao.dart';
import 'package:elastic_run/dao/invoice_dao.dart';
import 'package:elastic_run/dao/invoice_item_dao.dart';
import 'package:elastic_run/main.dart';
import 'package:elastic_run/models/inventry_model.dart';
import 'package:elastic_run/screens/sales_data/bloc/sales_event.dart';
import 'package:elastic_run/screens/sales_data/bloc/sales_state.dart';
import 'package:elastic_run/screens/sales_data/models/supporting_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesDataBloc extends Bloc<SalesDataEvent, SalesDataState> {
  final CustomerDao _customerDao = CustomerDao(database!);
  final InventoryDao _inventoryDao = InventoryDao(database!);
  final InvoiceDao _invoiceDao = InvoiceDao(database!);
  final InvoiceItemDao _invoiceItemDao = InvoiceItemDao(database!);

  SalesDataBloc() : super(SalesDataInitial()) {
    on<FetchSalesDataEvent>(_fetchSalesData);
  }

  Future<void> _fetchSalesData(
      FetchSalesDataEvent event, Emitter<SalesDataState> emit) async {
    emit(SalesDataLoading());
    try {
      final invoices = await _invoiceDao.getAllInvoices();
      final salesData = <SalesData>[];
      for (var invoice in invoices) {
        final customer = await _customerDao.getCustomerById(invoice.customerId);
        final invoiceItems =
            await _invoiceItemDao.getInvoiceItemsByInvoiceId(invoice.id ?? 0);

        final products = <ProductDetails>[];
        for (var item in invoiceItems) {
          final Inventory? inventory =
              await _inventoryDao.getInventoryByItemId(item.itemId);
          products.add(
            ProductDetails(
              name: inventory?.itemName ?? '',
              quantity: item.quantity,
            ),
          );
        }

        salesData.add(SalesData(
          invoiceId: invoice.id ?? 0,
          customerName: customer?.customerName ?? '',
          products: products,
        ));
      }

      emit(SalesDataLoaded(salesData));
    } catch (e) {
      emit(SalesDataError('Failed to fetch sales data: ${e.toString()}'));
    }
  }
}
