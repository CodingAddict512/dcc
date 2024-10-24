import 'dart:async';
import 'dart:math';

import 'package:dcc/cubits/metric_type_cubit.dart';
import 'package:dcc/cubits/states/metric_type_state.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

String roundDouble(double value, int places) {
  // double mod = pow(10.0, places);
  double mod = pow(10.0, places) as double;
  return ((value * mod).round().toDouble() / mod).toStringAsFixed(places);
}

class RegisterWeight extends StatelessWidget {
  static final TextInputFormatter digitsAndDecimalOnly =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'));

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _weightController = TextEditingController();
  final int amount;
  final MetricType metric;
  final int actualAmount;
  final MetricType actualMetric;
  final String weight;

  RegisterWeight({
    required this.amount,
    required this.metric,
    required this.actualAmount,
    required this.actualMetric,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);
    int _amount = amount;
    MetricType _metric = metric;
    String _weight = weight;
    StreamController<MetricType> metricStreamController =
        StreamController<MetricType>();

    _amount = actualAmount;
    _metric = actualMetric;

    /* Provide an initial value */
    metricStreamController.onListen = () => metricStreamController.add(_metric);

    Widget loading() {
      return Center(child: CircularProgressIndicator());
    }

    Widget metricDropdown(List<MetricType> metrics) {
      // metrics.sort((a, b) => (a.metric ?? 0).compareTo((b.metric ?? 0)));
      metrics.sort((a, b) {
        // Cast a and b to int. If they are null, treat them as 0.
        final aValue = (a as int?) ?? 0;
        final bValue = (b as int?) ?? 0;

        // Compare the two values and return the result
        return aValue.compareTo(bValue);
      });

      return StreamBuilder<MetricType>(
        builder: (context, mtSnapshot) => DropdownButton<MetricType>(
          value: mtSnapshot.data,
          icon: Icon(Icons.arrow_drop_down),
          isExpanded: true,
          onChanged: (newMetricType) {
            _metric = newMetricType!;
            metricStreamController.add(_metric);
          },
          items: metrics
              .map((mt) => DropdownMenuItem<MetricType>(
                    value: mt,
                    child: Text(mt.toString()),
                  ))
              .toList(),
        ),
        stream: metricStreamController.stream,
      );
    }

    Widget metricSelection() {
      return BlocBuilder<MetricTypeCubit, MetricTypeState>(
        builder: (context, state) {
          if (state is MetricTypeStateLoaded) {
            final metrics = state.getActiveMetricTypes();
            if (metrics.length > 0) {
              return metricDropdown(metrics);
            }
            return Text(
              localizations!.translate("registerWeightMetricsNotAvailable"),
            );
          }
          return loading();
        },
      );
    }

    Widget amountInput() {
      return TextFormField(
        autofocus: true,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        controller: _amountController,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: _amount.toString(),
        ),
        validator: (value) {
          if (value!.isNotEmpty) {
            try {
              final a = int.parse(value);
              if (a < 0) {
                return localizations!
                    .translate("registerWeightErrorNeedPositiveInteger");
              }
            } catch (FormatException) {
              return localizations!
                  .translate("registerWeightErrorNeedPositiveInteger");
            }
          }
          return null;
        },
      );
    }

    Widget weightInput() {
      return TextFormField(
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: true,
        ),
        controller: _weightController,
        inputFormatters: [
          digitsAndDecimalOnly,
        ],
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: _weight ?? "",
        ),
        validator: (value) {
          if (value!.isNotEmpty) {
            try {
              final a = double.parse(value);
              if (a < 0.0) {
                return localizations!
                    .translate("registerWeightErrorNeedPositiveNumber");
              }
            } catch (FormatException) {
              return localizations!
                  .translate("registerWeightErrorNeedPositiveNumber");
            }
          }
          return null;
        },
      );
    }

    TableRow amountRow() {
      return TableRow(
        children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Text(localizations!.translate("registerWeightAmountTitle")),
          ),
          amountInput(),
        ],
      );
    }

    TableRow metricRow() {
      return TableRow(
        children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Text(localizations!.translate("registerWeightMetricTitle")),
          ),
          metricSelection(),
        ],
      );
    }

    TableRow weightRow() {
      return TableRow(
        children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Text(localizations!.translate("registerWeightWeightTitle")),
          ),
          weightInput(),
        ],
      );
    }

    return Form(
      key: _formKey,
      child: AlertDialog(
        content: Table(
          children: [
            amountRow(),
            metricRow(),
            weightRow(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: Text(localizations!.translate("registerWeightCancel")),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                String a = _amountController.text;
                if (a.isNotEmpty) {
                  _amount = int.parse(a);
                }
                String w = _weightController.text;
                if (w.isNotEmpty) {
                  _weight = roundDouble(double.parse(w), 2);
                }
                final result = AmountMetricWeight(
                  amount: _amount,
                  metric: _metric,
                  weight: _weight,
                );
                navigator.pop(result);
              }
            },
            child: Text(localizations!.translate("registerWeightComplete")),
          ),
        ],
      ),
    );
  }
}

class AmountMetricWeight {
  final amount;
  final MetricType metric;
  final String weight;

  AmountMetricWeight({this.amount, required this.metric, required this.weight});
}
