import 'package:elastic_run/color/er_color.dart';
import 'package:elastic_run/extensions/containers.dart';
import 'package:elastic_run/extensions/navigation.dart';
import 'package:elastic_run/extensions/text.dart';
import 'package:elastic_run/reusable_widgets/app_image.dart';
import 'package:elastic_run/reusable_widgets/er_widgets.dart';
import 'package:elastic_run/screens/add_customer/add_customer_screen.dart';
import 'package:elastic_run/screens/future_scopes/future_scopes.dart';
import 'package:elastic_run/screens/return_data/sales_return_screen.dart';
import 'package:elastic_run/screens/return_items/return_screen.dart';
import 'package:elastic_run/screens/sales_data/sales_data_screen.dart';
import 'package:elastic_run/screens/sales_invoice/sales_invoice_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  /// this file is very small so not added state management due to time constraints
  final String _logo = 'https://www.elastic.run/images/svg/elasticrun-logo.svg';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
              child: AppImage(
                _logo,
                height: 80,
              ),
            ),
            30.height,
            ErWidgets.filledButton(
                text: 'Add Customers',
                onPressed: () {
                  _navigateTo(
                      context: context, screenName: const AddCustomerScreen());
                }),
            12.height,
            ErWidgets.filledButton(
                text: 'Sales Invoice',
                onPressed: () {
                  _navigateTo(
                      context: context, screenName: const SalesInvoiceScreen());
                }),
            12.height,
            ErWidgets.filledButton(
                text: 'Sales History',
                onPressed: () {
                  _navigateTo(
                      context: context, screenName: const SalesDataScreen());
                }),
            12.height,
            ErWidgets.filledButton(
                text: 'Add Return',
                onPressed: () {
                  _navigateTo(
                      context: context, screenName: const ReturnItemsScreen());
                }),
            12.height,
            ErWidgets.filledButton(
                text: 'Return History',
                onPressed: () {
                _navigateTo(
                    context: context, screenName: const SalesReturnScreen());
              },
            ),

            12.height,
            ErWidgets.filledButton(
              text: 'Future Scopes of app',
              onPressed: () {
               _navigateTo(context: context, screenName: const FutureScopes());
              },
            ),
            20.height,
            'to check latest stock go to sales invoice in that you can check current stock'.semiBoldText(color: ErColor.red),
          ],
        ),
      ),
    );
  }
  void _navigateTo(
      {required BuildContext context, required Widget screenName}) {
    context.push(screenName);
  }
}
