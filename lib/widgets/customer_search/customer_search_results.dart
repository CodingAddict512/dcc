import 'package:dcc/models/customer.dart';
import 'package:dcc/models/customer_stub.dart';
import 'package:flutter/material.dart';

class CustomerSearchResults extends StatelessWidget {
  final List<CustomerStub> results;
  final Function(Customer customer) onSelection;

  CustomerSearchResults({@required this.results, this.onSelection});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Container(); //TODO: Show recent
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final c = results.elementAt(index);
        return InkWell(
          onTap: () async => this.onSelection(await c.resolveCustomer()),
          child: ListTile(
            leading: Icon(Icons.business),
            title: Text(c.customerName),
          ),
        );
      },
    );
  }
}
