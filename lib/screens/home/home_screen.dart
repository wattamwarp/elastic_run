import 'package:elastic_run/extensions/navigation.dart';
import 'package:elastic_run/reusable_widgets/er_widgets.dart';
import 'package:elastic_run/screens/add_customer/add_customer_screen.dart';
import 'package:elastic_run/screens/return_data/sales_return_screen.dart';
import 'package:elastic_run/screens/return_items/return_screen.dart';
import 'package:elastic_run/screens/sales_data/sales_data_screen.dart';
import 'package:elastic_run/screens/sales_invoice/sales_invoice_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ErWidgets.filledButton(
                text: 'Add Customers',
                onPressed: () {
                  context.push(const AddCustomerScreen());
                }),
            ErWidgets.filledButton(
                text: 'Sales Invoice',
                onPressed: () {
                  context.push(const SalesInvoiceScreen());
                }),
            ErWidgets.filledButton(
                text: 'Sales History',
                onPressed: () {
                  context.push(const SalesDataScreen());
                }),
            ErWidgets.filledButton(
                text: 'Add Return',
                onPressed: () {
                  context.push(const ReturnItemsScreen());
                }),
            ErWidgets.filledButton(
                text: 'Return History',
                onPressed: () {
                  context.push(const SalesReturnScreen());
                }),

          ],
        ),
      ),
    );
  }
}
