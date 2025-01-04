import 'package:elastic_run/screens/sales_data/bloc/sales_bloc.dart';
import 'package:elastic_run/screens/sales_data/bloc/sales_event.dart';
import 'package:elastic_run/screens/sales_data/bloc/sales_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalesDataBloc(
      )..add(FetchSalesDataEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sales Data'),
        ),
        body: BlocBuilder<SalesDataBloc, SalesDataState>(
          builder: (context, state) {
            if (state is SalesDataLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SalesDataLoaded) {
              final salesData = state.salesData;

              if (salesData.isEmpty) {
                return Center(child: Text('No sales data available.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: salesData.length,
                itemBuilder: (context, index) {
                  final sale = salesData[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer: ${sale.customerName}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text('Invoice ID: ${sale.invoiceId}'),
                          SizedBox(height: 8.0),
                          Text(
                            'Products:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          ...sale.products.map((product) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                '- ${product.name} (Quantity: ${product.quantity})',
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is SalesDataError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            }

            return Center(child: Text('No data available.'));
          },
        ),
      ),
    );
  }
}
