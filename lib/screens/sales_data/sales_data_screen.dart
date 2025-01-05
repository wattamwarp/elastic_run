import 'package:elastic_run/color/er_color.dart';
import 'package:elastic_run/extensions/containers.dart';
import 'package:elastic_run/extensions/text.dart';
import 'package:elastic_run/screens/sales_data/bloc/sales_bloc.dart';
import 'package:elastic_run/screens/sales_data/bloc/sales_event.dart';
import 'package:elastic_run/screens/sales_data/bloc/sales_state.dart';
import 'package:elastic_run/screens/sales_data/models/supporting_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesDataScreen extends StatelessWidget {
  const SalesDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalesDataBloc()..add(FetchSalesDataEvent()),
      child: const Scaffold(
        appBar: _SalesDataAppBar(),
        body: _SalesDataBody(),
      ),
    );
  }
}

class _SalesDataAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SalesDataAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: 'Sales Data'.boldText(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SalesDataBody extends StatelessWidget {
  const _SalesDataBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesDataBloc, SalesDataState>(
      builder: (context, state) {
        if (state is SalesDataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SalesDataLoaded) {
          return _SalesDataList(salesData: state.salesData);
        } else if (state is SalesDataError) {
          return _ErrorMessage(message: state.message);
        }

        return const _NoDataMessage();
      },
    );
  }
}

class _SalesDataList extends StatelessWidget {
  final List<SalesData> salesData;

  const _SalesDataList({required this.salesData, super.key});

  @override
  Widget build(BuildContext context) {
    if (salesData.isEmpty) {
      return Center(
          child: 'No sales data available.'.boldText(color: ErColor.red));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: salesData.length,
      itemBuilder: (context, index) {
        final sale = salesData[index];
        return _SalesDataCard(sale: sale);
      },
    );
  }
}

class _SalesDataCard extends StatelessWidget {
  final SalesData sale;

  const _SalesDataCard({required this.sale, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            'Customer: ${sale.customerName}'.boldText(fontSize: 18),
            8.height,
            'Invoice ID: ${sale.invoiceId}'.normalText(),
            8.height,
            'Products:'.semiBoldText(),
            ...sale.products.map((product) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: '- ${product.name} (Quantity: ${product.quantity})'
                    .normalText(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;

  const _ErrorMessage({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: 'Error: $message'.semiBoldText(color: ErColor.red),
    );
  }
}

class _NoDataMessage extends StatelessWidget {
  const _NoDataMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: 'No data available.'.semiBoldText(color: ErColor.red),
    );
  }
}
