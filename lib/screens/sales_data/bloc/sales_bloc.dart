import 'package:elastic_run/dao/customer_dao.dart';
import 'package:elastic_run/dao/inventory_dao.dart';
import 'package:elastic_run/dao/invoice_dao.dart';
import 'package:elastic_run/dao/invoice_item_dao.dart';
import 'package:elastic_run/main.dart';
import 'package:elastic_run/models/customer_model.dart';
import 'package:elastic_run/models/inventry_model.dart';
import 'package:elastic_run/models/invoice_model.dart';
import 'package:elastic_run/screens/sales_data/bloc/sales_event.dart';
import 'package:elastic_run/screens/sales_data/bloc/sales_state.dart';
import 'package:elastic_run/screens/sales_data/models/supporting_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesDataBloc extends Bloc<SalesDataEvent, SalesDataState> {
  final CustomerDao _customerDao = CustomerDao(database!);
  final InventoryDao _inventoryDao = InventoryDao(database!);
  final InvoiceDao _invoiceDao = InvoiceDao();
  final InvoiceItemDao _invoiceItemDao = InvoiceItemDao(database!);

  SalesDataBloc() : super(SalesDataInitial()) {
    on<FetchSalesDataEvent>(_fetchSalesData);
  }

  Future<void> _fetchSalesData(
      FetchSalesDataEvent event, Emitter<SalesDataState> emit) async {
    emit(SalesDataLoading());
    try {
      final List<Invoice> invoices = await _invoiceDao.getAllInvoices();
      final List<SalesData> salesData = await _generateSalesData(invoices);

      emit(SalesDataLoaded(salesData));
    } catch (e) {
      emit(SalesDataError('Failed to fetch sales data: ${e.toString()}'));
    }
  }

  Future<List<SalesData>> _generateSalesData(List<Invoice> invoices) async {
    final List<SalesData> salesData = <SalesData>[];

    for (var invoice in invoices) {
      final Customer? customer = await _getCustomer(invoice.customerId);
      final List<ProductDetails> products = await _getProducts(invoice.id);

      salesData.add(
        SalesData(
          invoiceId: invoice.id ?? 0,
          customerName: customer?.customerName ?? '',
          products: products,
        ),
      );
    }

    return salesData;
  }

  Future<Customer?> _getCustomer(int? customerId) async {
    return await _customerDao.getCustomerById(customerId ?? 1);
  }

  Future<List<ProductDetails>> _getProducts(int? invoiceId) async {
    final invoiceItems =
        await _invoiceItemDao.getInvoiceItemsByInvoiceId(invoiceId ?? 0);
    final List<ProductDetails> products = <ProductDetails>[];

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

    return products;
  }
}