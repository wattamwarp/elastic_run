import 'package:elastic_run/models/customer_model.dart';
import 'package:elastic_run/models/inventry_model.dart';
import 'package:elastic_run/screens/sales_invoice/bloc/sales_invoice_bloc.dart';
import 'package:elastic_run/screens/sales_invoice/bloc/sales_invoice_event.dart';
import 'package:elastic_run/screens/sales_invoice/bloc/sales_invoice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesInvoiceScreen extends StatelessWidget {
  const SalesInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => SalesInvoiceBloc()
        ..add(FetchInventoryEvent()),
      child: Scaffold(
        appBar: AppBar(title: Text('Sales Invoice')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
               _CustomerDropdown(),
              const SizedBox(height: 16.0),
              Expanded(child: _InventoryList()),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerDropdown extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesInvoiceBloc, SalesInvoiceState>(
      builder: (context, state) {
        if (state is SalesInvoiceInitial) {
          return Text("Select a customer");
        } else if (state is CustomerSelected) {
          return Text('Selected Customer: ${state.customer.customerName}');
        }

        return DropdownButton<Customer>(
          hint: Text("Select Customer"),
          onChanged: (customer) {
            if (customer != null) {
              context
                  .read<SalesInvoiceBloc>()
                  .add(SelectCustomerEvent(customer: customer));
            }
          },
          items: [...state.customers].map<DropdownMenuItem<Customer>>((Customer customer) {
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesInvoiceBloc, SalesInvoiceState>(
      builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is InventoryLoaded || state is CustomerSelected) {
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: state.inventoryItems.length,
                itemBuilder: (context, index) {
                  final Inventory item = state.inventoryItems[index];
                  return ListTile(
                    title: Text(item.itemName),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Quantity: ${item.quantity}'),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: state.controllers[index],
                            decoration:
                                const InputDecoration(labelText: 'Quantity to sell'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Container(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<SalesInvoiceBloc>()
                        .add(CreateInvoiceEvent( context: context));
                  },
                  child: Text('Create Invoice'),
                ),
              )

            ],
          );
        }
        return const Center(child: Text('No inventory available.'));
      },
    );
  }
}
