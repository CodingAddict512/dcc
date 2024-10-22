import 'package:dcc/models/customer.dart';
import 'package:dcc/style/dcc_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailsCustomerNotes extends StatelessWidget {
  final Customer customer;

  DetailsCustomerNotes(this.customer);

  @override
  Widget build(BuildContext context) {
    if (customer.notes == null || customer.notes.length == 0) {
      return Container();
    }

    return ListTile(
      leading: Icon(
        Icons.sticky_note_2_outlined,
        color: Colors.deepOrange,
      ),
      title: Text(
        customer.notes,
        style: DccTextStyles.pickupDetails.customerNotes,
      ),
    );
  }
}
