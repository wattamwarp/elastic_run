import 'package:elastic_run/dao/customer_dao.dart';
import 'package:elastic_run/dao/inventory_dao.dart';
import 'package:elastic_run/dao/invoice_dao.dart';
import 'package:elastic_run/dao/invoice_item_dao.dart';
import 'package:elastic_run/dao/item_dao.dart';
import 'package:elastic_run/db/db_helper.dart';
import 'package:elastic_run/main.dart';
import 'package:elastic_run/models/inventry_model.dart';
import 'package:elastic_run/models/invoice_model.dart';
import 'package:sqflite/sqflite.dart';

class ReturnProcessor {
  final CustomerDao _customerDao = CustomerDao(database!);
  final InventoryDao _inventoryDao = InventoryDao(database!);
  final InvoiceDao _invoiceDao = InvoiceDao(database!);
  final InvoiceItemDao _invoiceItemDao = InvoiceItemDao(database!);

  ReturnProcessor();

  /// Main method to process returns
  Future<void> processReturns(Map<String, int> returnedItems) async {
    Database db = await DatabaseHelper().database;
    await db.transaction((txn) async {
      for (final entry in returnedItems.entries) {
        final String itemCode = entry.key;
        final int returnQuantity = entry.value;

        // Fetch item ID using DAO method
        final Inventory? itemId = await _inventoryDao.getInventoryByItemId(txn, 1);

        // Fetch the total sold quantity for this item
        final int totalSold =
            await invoiceItemDao.getTotalSoldQuantityForItem(txn, itemId);

        // Validate return quantity
        if (returnQuantity > totalSold) {
          throw Exception(
              'Invalid return quantity for $itemCode: Returning $returnQuantity, but total sold is $totalSold.');
        }

        // Fetch all invoices containing the item
        final List<Invoice> invoices =
            await invoiceDao.getInvoicesForItem(txn, itemId);

        // Process returns
        await _processFullReturns(txn, invoices, itemId);
      }
    });
  }

  /// Process returns for the given invoices
  Future<void> _processFullReturns(
      Transaction txn, List<Invoice> invoices, int itemId) async {
    for (final invoice in invoices) {
      // Fetch the quantity from the InvoiceItem table using DAO method
      final invoiceItem = await invoiceItemDao
          .getInvoiceItemByInvoiceIdAndItemId(txn, invoice.id!, itemId);

      final int invoiceItemId = invoiceItem.id!;
      final int customerId = invoice.customerId;
      final int soldQuantity =
          invoiceItem.quantity; // Fetch quantity from InvoiceItem

      // Create a new Sales Return invoice using DAO method
      final int salesReturnId =
          await invoiceDao.createSalesReturnInvoice(txn, customerId);

      // Add return item to the new Sales Return invoice using DAO method
      await invoiceItemDao.addReturnItem(
          txn, salesReturnId, itemId, soldQuantity);

      // Soft delete the original sale invoice item using DAO method
      await invoiceItemDao.softDeleteInvoiceItem(txn, invoiceItemId);
    }
  }
}
