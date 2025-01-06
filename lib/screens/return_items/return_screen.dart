import 'package:elastic_run/extensions/containers.dart';
import 'package:elastic_run/extensions/text.dart';
import 'package:elastic_run/reusable_widgets/er_widgets.dart';
import 'package:elastic_run/screens/return_items/cubit/return_bloc.dart';
import 'package:elastic_run/screens/return_items/cubit/return_event.dart';
import 'package:elastic_run/screens/return_items/cubit/return_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReturnItemsScreen extends StatelessWidget {
  const ReturnItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      /// Initializes the `ReturnBloc` only when required for better resource usage.
      create: (context) => ReturnBloc(context)..add(LoadInventoryEvent()),
      child: Scaffold(
        appBar: AppBar(title: 'Process Returns'.boldText()),
        body: BlocBuilder<ReturnBloc, ReturnState>(
          builder: (context, state) {
            if (state.inventoryItems.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.inventoryItems.length,
                    itemBuilder: (context, index) {
                      final inventoryItem = state.inventoryItems[index];
                      return ListTile(
                        title: inventoryItem.itemName.normalText(),
                        trailing: SizedBox(
                          width: 100,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final quantity = int.tryParse(value) ?? 0;
                              if (quantity > 0) {
                                context.read<ReturnBloc>().add(
                                      UpdateReturnQuantityEvent(
                                        itemId: inventoryItem.itemId ?? 0,
                                        quantity: quantity,
                                  ),
                                );
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: 'Return Qty',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                20.height,
                ErWidgets.filledButton(
                  text: 'Create Return Entry',
                  onPressed: () {
                    context.read<ReturnBloc>().add(SubmitReturnEvent());
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
