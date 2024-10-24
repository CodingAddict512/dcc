import 'package:dcc/models/customer.dart';
import 'package:dcc/models/customer_stub.dart';
import 'package:dcc/pages/customer_search.dart';
import 'package:flutter/material.dart';

class CustomerSelection extends StatelessWidget {
  final void Function(Customer customer) onSelection;
  final String title;
  final List<CustomerStub> customers;
  final List<CustomerStub> recent;
  final bool isReceiver;
  final bool enabled;

  CustomerSelection({
    required this.title,
    required this.onSelection,
    required this.customers,
    required this.recent,
    this.isReceiver = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return InkWell(
      onTap: enabled
          ? () async {
              final result = await navigator.push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return CustomerSearch(
                    customers: customers,
                    recent: recent,
                    isReceiver: isReceiver,
                  );
                }),
              );

              if (result != null && result is Customer) {
                onSelection(result);
              }
            }
          : null,
      child: ListTile(
        leading: Icon(Icons.business),
        title: Text(title),
      ),
    );
  }
}
