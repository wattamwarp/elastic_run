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
        create: (context) => ReturnBloc(context)..add(LoadInventoryEvent()),
        child: _ReturnScreen());
  }
}

class _ReturnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: 'Process Returns'.boldText()),
      body: BlocBuilder<ReturnBloc, ReturnState>(
        builder: (context, state) {
          if (state.inventoryItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: state.inventoryItems.length,
                itemBuilder: (context, index) {
                  final inventoryItem = state.inventoryItems[index];
                  final itemId = inventoryItem.itemId;
                  return ListTile(
                    title: Text(inventoryItem.itemName),

                    trailing: SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final int quantity = int.tryParse(value) ?? 0;
                          if (quantity > 0) {
                            context.read<ReturnBloc>().add(
                                  UpdateReturnQuantityEvent(
                                    itemId: itemId ?? 0,
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
              20.height,
              ErWidgets.filledButton(
                  text: 'create return entry',
                  onPressed: () {
                    context.read<ReturnBloc>().add(SubmitReturnEvent());
                  }),
            ],
          );
        },
      ),
    );
  }
}
