import 'package:elastic_run/color/er_color.dart';
import 'package:elastic_run/extensions/containers.dart';
import 'package:elastic_run/extensions/text.dart';
import 'package:elastic_run/models/sales_return.dart';
import 'package:elastic_run/models/sales_return_item.dart';
import 'package:elastic_run/screens/return_data/bloc/sales_return_bloc.dart';
import 'package:elastic_run/screens/return_data/bloc/sales_return_event.dart';
import 'package:elastic_run/screens/return_data/bloc/sales_return_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesReturnScreen extends StatelessWidget {
  const SalesReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: 'Return History'.boldText(fontSize: 18),
        ),
        /// Instead of initializing at the app's start in a MultiBlocProvider,
        /// this is initialized only when required to optimize resource usage.
        body: BlocProvider(
          create: (context) => SalesReturnBloc()..add(LoadSalesReturnsEvent()),
          child: const _SalesReturnBody(),
        ),
      ),
    );
  }
}

/// stateless widgets are more faster than widget method
class _SalesReturnBody extends StatelessWidget {
  const _SalesReturnBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesReturnBloc, SalesReturnState>(
      builder: (context, state) {
        if (state is SalesReturnInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SalesReturnError) {
          return _ErrorView(error: state.error);
        } else if (state is SalesReturnLoaded) {
          return _SalesReturnList(salesReturns: state.salesReturns);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;

  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(child: 'Error: $error'.boldText(color: ErColor.red));
  }
}

class _SalesReturnList extends StatelessWidget {
  final List<SalesReturn> salesReturns;

  const _SalesReturnList({required this.salesReturns});

  @override
  Widget build(BuildContext context) {
    if (salesReturns.isEmpty) {
      return Center(
          child: 'No sales returns found.'.boldText(color: ErColor.red));
    }

    return ListView.builder(
      itemCount: salesReturns.length,
      itemBuilder: (context, index) {
        final salesReturn = salesReturns[index];
        return _SalesReturnCard(salesReturn: salesReturn);
      },
    );
  }
}

class _SalesReturnCard extends StatelessWidget {
  final SalesReturn salesReturn;

  const _SalesReturnCard({required this.salesReturn});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            'Invoice No: ${salesReturn.id}'.boldText(fontSize: 16),
            'Customer: ${salesReturn.customerName}'.semiBoldText(fontSize: 16),
            8.height,
            'Returned Items:'.semiBoldText(),
            ...salesReturn.items.map((item) => _SalesReturnItem(item: item)),
          ],
        ),
      ),
    );
  }
}

class _SalesReturnItem extends StatelessWidget {
  final SalesReturnItem item;

  const _SalesReturnItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          item.itemName.toString().normalText(),
          'Qty: ${item.quantity}'.normalText(),
        ],
      ),
    );
  }
}
