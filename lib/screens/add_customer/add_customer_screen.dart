import 'package:elastic_run/color/er_color.dart';
import 'package:elastic_run/extensions/containers.dart';
import 'package:elastic_run/extensions/text.dart';
import 'package:elastic_run/reusable_widgets/custom_box.dart';
import 'package:elastic_run/reusable_widgets/er_widgets.dart';
import 'package:elastic_run/screens/add_customer/bloc/customer_bloc.dart';
import 'package:elastic_run/screens/add_customer/bloc/customer_event.dart';
import 'package:elastic_run/screens/add_customer/bloc/customer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Instead of initializing at the app's start in a MultiBlocProvider,
    /// this is initialized only when required to optimize resource usage.
    return BlocProvider(
      create: (context) => CustomerBloc()..add(FetchCustomersEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: 'Add Customer'.boldText(fontSize: 18),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              _CustomerInputField(),
              SizedBox(height: 16),
              Expanded(child: _CustomerList()),
            ],
          ),
        ),
      ),
    );
  }
}

/// stateless widgets are more faster than widget method
class _CustomerInputField extends StatefulWidget {
  const _CustomerInputField();

  @override
  State<_CustomerInputField> createState() => _CustomerInputFieldState();
}

class _CustomerInputFieldState extends State<_CustomerInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addCustomer(BuildContext context) {
    final customerName = _controller.text.trim();
    if (customerName.isNotEmpty) {
      context.read<CustomerBloc>().add(AddCustomerEvent(name: customerName));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Customer Name',
            border: OutlineInputBorder(),
          ),
        ),
        16.height,
        ErWidgets.filledButton(
          text: 'Add Customers',
          onPressed: () => _addCustomer(context),
        ),
      ],
    );
  }
}

class _CustomerList extends StatelessWidget {
  const _CustomerList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state is CustomerLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CustomerLoaded) {
          return state.customers.isEmpty
              ? Center(child: 'No customers yet.'.boldText(color: ErColor.red))
              : ListView.builder(
                  itemCount: state.customers.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        6.height,
                        state.customers[index].customerName
                            .semiBoldText(fontSize: 16),
                        6.height,
                        CustomBox(
                          height: 1,
                          width: double.infinity,
                          color: ErColor.grey,
                        )
                      ],
                    );
                  },
                );
        } else if (state is CustomerError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
