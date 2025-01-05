import 'package:elastic_run/color/er_color.dart';
import 'package:elastic_run/extensions/text.dart';
import 'package:elastic_run/models/customer_model.dart';
import 'package:elastic_run/models/inventry_model.dart';
import 'package:elastic_run/reusable_widgets/er_widgets.dart';
import 'package:elastic_run/screens/sales_invoice/bloc/sales_invoice_bloc.dart';
import 'package:elastic_run/screens/sales_invoice/bloc/sales_invoice_event.dart';
import 'package:elastic_run/screens/sales_invoice/bloc/sales_invoice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesInvoiceScreen extends StatelessWidget {
  const SalesInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalesInvoiceBloc()..add(FetchInventoryEvent()),
      child: Scaffold(
        appBar: AppBar(title: 'Sales Invoice'.boldText()),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              _CustomerDropdown(),
              SizedBox(height: 16.0),
              Expanded(child: _InventoryList()),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerDropdown extends StatelessWidget {
  const _CustomerDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesInvoiceBloc, SalesInvoiceState>(
      builder: (context, state) {
        if (state is SalesInvoiceInitial) {
          return 'Select a customer'.semiBoldText();
        } else if (state is CustomerSelected) {
          return 'Selected Customer: ${state.customer.customerName}'
              .semiBoldText();
        }

        return DropdownButton<Customer>(
          hint: "Select Customer".semiBoldText(),
          onChanged: (customer) {
            if (customer != null) {
              context
                  .read<SalesInvoiceBloc>()
                  .add(SelectCustomerEvent(customer: customer));
            }
          },
          items: state.customers
              .map<DropdownMenuItem<Customer>>((Customer customer) {
            return DropdownMenuItem<Customer>(
              value: customer,
              child: Text(customer.customerName),
            );
          }).toList(),
        );
      },
    );
  }
}

class _InventoryList extends StatelessWidget {
  const _InventoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesInvoiceBloc, SalesInvoiceState>(
      builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is InventoryLoaded || state is CustomerSelected) {
          return Column(
            children: [
              _InventoryListView(inventoryItems: state.inventoryItems),
              const SizedBox(height: 16),
              ErWidgets.filledButton(
                text: 'Create Invoice',
                onPressed: () {
                  context
                      .read<SalesInvoiceBloc>()
                      .add(CreateInvoiceEvent(context: context));
                },
              ),
            ],
          );
        }
        return Center(
          child: 'No inventory available.'.boldText(color: ErColor.red),
        );
      },
    );
  }
}

class _InventoryListView extends StatelessWidget {
  final List<Inventory> inventoryItems;

  const _InventoryListView({required this.inventoryItems, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: inventoryItems.length,
      itemBuilder: (context, index) {
        final Inventory item = inventoryItems[index];
        return _InventoryListTile(item: item, index: index);
      },
    );
  }
}

class _InventoryListTile extends StatelessWidget {
  final Inventory item;
  final int index;

  const _InventoryListTile(
      {required this.item, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.itemName),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Quantity: ${item.quantity}'),
          SizedBox(
            width: 170,
            child: TextField(
              controller:
                  context.read<SalesInvoiceBloc>().state.controllers[index],
              decoration: const InputDecoration(labelText: 'Quantity to sell'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
