import 'package:elastic_run/color/er_color.dart';
import 'package:elastic_run/extensions/containers.dart';
import 'package:elastic_run/extensions/navigation.dart';
import 'package:elastic_run/extensions/text.dart';
import 'package:elastic_run/models/customer_model.dart';
import 'package:elastic_run/screens/add_customer/bloc/customer_bloc.dart';
import 'package:elastic_run/screens/add_customer/bloc/customer_event.dart';
import 'package:elastic_run/screens/add_customer/bloc/customer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(  create: (context) => CustomerBloc()..add(FetchCustomersEvent()),
    child: _AddCustomerScreen(),);
  }
}


class _AddCustomerScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: 'Add Customer'.boldText()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                border: OutlineInputBorder(),
              ),
            ),
     16.height,
            ElevatedButton(
              onPressed: () {
                final customerName = _controller.text;
                if (customerName.isNotEmpty) {
                  BlocProvider.of<CustomerBloc>(context)
                      .add(AddCustomerEvent(name: customerName));
                  _controller.clear();
                }
              },
              child: 'Add Customer'.normalText(),
            ),
       16.height,
            Expanded(
              child: BlocBuilder<CustomerBloc, CustomerState>(
                builder: (context, state) {
                  if (state is CustomerLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CustomerLoaded) {
                    final List<Customer>  customers = state.customers;
                    if(customers.isEmpty){
                      return  Center(child: 'No customers yet.'.boldText(color: ErColor.red));
                    }
                    return ListView.builder(
                      itemCount: customers.length,
                      itemBuilder: (context, index) {
                        final customer = customers[index];
                        return ListTile(
                          title:customer.customerName.normalText(),
                        );
                      },
                    );
                  } else if (state is CustomerError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                return 0.height;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
