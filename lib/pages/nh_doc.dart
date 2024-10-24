import 'package:dcc/cubits/car_cubit.dart';
import 'package:dcc/cubits/final_disposition_cubit.dart';
import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/cubits/states/car_state.dart';
import 'package:dcc/cubits/states/final_disposition_state.dart';
import 'package:dcc/cubits/states/pickups_state.dart';
import 'package:dcc/cubits/states/transporter_state.dart';
import 'package:dcc/cubits/transporter_cubit.dart';
import 'package:dcc/extensions/nh_category.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/car.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/final_disposition.dart';
import 'package:dcc/models/nh_category.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/transporter.dart';
import 'package:dcc/style/dcc_text_styles.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
import 'package:dcc/widgets/nh_doc/icon_tile.dart';
import 'package:flutter/material.dart';

class NhDocPage extends StatelessWidget {
  Widget loading() => Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    Widget appBar() {
      return AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            navigator.pop();
          },
        ),
      );
    }

    Widget sectionTitle(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          title,
          style: DccTextStyles.nhDoc.sectionTitle,
        ),
      );
    }

    Widget title() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          localizations!.translate("nhDocPageTitle"),
          textAlign: TextAlign.start,
          style: DccTextStyles.nhDoc.mainTitle,
        ),
      );
    }

    Widget date(String deadline) {
      return IconTile(
        icon: Icon(Icons.event),
        title: localizations!.translate("nhDocPageDateOfPickupLabel"),
        description: deadline,
      );
    }

    Widget referenceNumber() {
      return IconTile(
        icon: Icon(Icons.credit_card),
        title: localizations!.translate("nhDocPageLocalRefLabel"),
        description: localizations!.translate("nhDocPageLocalRefMissing"),
      );
    }

    Widget category(Pickup pickup) {
      Widget categoryBox(NHCategory c, NHCategory nhCategory) {
        return CheckboxListTile(
          title: Text(c.name()),
          value: c == nhCategory,
          onChanged: null,
        );
      }

      return BlocSubStateBuilder<FinalDispositionCubit, FinalDispositionState,
          FinalDispositionStateLoaded>(
        subStateBuilder: (context, state) {
          final FinalDisposition finalDisposition =
              state.id2disposition[pickup.finalDispositionId]!;
          final categories = NHCategory.values
              .map((c) => categoryBox(c, finalDisposition.category))
              .toList();
          return Column(
            children: [
              Text(
                localizations!
                    .translate("nhDocPageFinalDispositionCategoryLabel"),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...categories,
            ],
          );
        },
        fallbackBuilder: (context, state) => loading(),
      );
    }

    Widget cateogry3Extra() {
      return IconTile(
        icon: Icon(Icons.add),
        title: localizations!.translate("nhDocPageCategory3ExtraLabel"),
        description: "",
      );
    }

    Widget amountOrWeight(String amount, String weight) {
      return IconTile(
        icon: Icon(Icons.storage),
        title:
            localizations!.translate("nhDocPageAmountOrRegisteredWeightLabel"),
        description: weight ?? amount,
      );
    }

    Widget finalDispositionType(String type) {
      return IconTile(
        icon: Icon(Icons.category),
        title: localizations!
            .translate("nhDocPageFinalDispositionDescriptionLabel"),
        description: type,
      );
    }

    Widget origin(Customer customer) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(localizations!.translate("nhDocPageOriginSectionTitle")),
          IconTile(
            icon: Icon(null),
            title: localizations!.translate("nhDocPageOriginNameLabel"),
            description: customer.name,
          ),
          IconTile(
            icon: Icon(null),
            title: localizations!.translate("nhDocPageOriginAddressLabel"),
            description:
                "${customer.streetName} ${customer.streetBuildingIdentifier ?? ''}",
          ),
          IconTile(
            icon: Icon(null),
            title: localizations!
                .translate("nhDocPageOriginPostCodeIdentifierLabel"),
            description: customer.postCodeIdentifier,
          ),
          IconTile(
            icon: Icon(null),
            title: localizations!.translate("nhDocPageOriginDistrictNameLabel"),
            description: customer.districtName,
          ),
          IconTile(
            icon: Icon(null),
            title:
                localizations!.translate("nhDocPageOriginCertificateAbNrLabel"),
            description: customer.certificateAbNr,
          ),
        ],
      );
    }

    Widget transporter(Transporter transporter, Car car) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(
              localizations!.translate("nhDocPageTransporterSectionTitle")),
          IconTile(
            icon: Icon(null),
            title: localizations!.translate("nhDocPageTransporterNameLabel"),
            description: transporter.name,
          ),
          IconTile(
            icon: Icon(null),
            title: localizations!.translate("nhDocPageTransporterAddressLabel"),
            description: transporter.streetName,
          ),
          IconTile(
            icon: Icon(null),
            title: localizations!
                .translate("nhDocPageTransporterPostCodeIdentifierLabel"),
            description: transporter.postCodeIdentifier,
          ),
          IconTile(
            icon: Icon(null),
            title: localizations!
                .translate("nhDocPageTransporterDistrictNameLabel"),
            description: transporter.districtName,
          ),
          IconTile(
            icon: Icon(null),
            title: localizations!.translate("nhDocPageTransporterRegNrLabel"),
            description: car.licensePlate,
          ),
        ],
      );
    }

    Widget receiver(Customer customer) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(
              localizations!.translate("nhDocPageReceiverSectionTitle")),
          IconTile(
            icon: Icon(null),
            title: localizations!.translate("nhDocPageReceiverNameLabel"),
            description: customer.name,
          ),
          IconTile(
            icon: Icon(null),
            title: localizations!.translate("nhDocPageReceiverAddressLabel"),
            description:
                "${customer.streetName} ${customer.streetBuildingIdentifier ?? ''}",
          ),
          IconTile(
            icon: Icon(null),
            title: localizations!
                .translate("nhDocPageReceiverPostCodeIdentifierLabel"),
            description: customer.postCodeIdentifier,
          ),
          IconTile(
            icon: Icon(null),
            title:
                localizations!.translate("nhDocPageReceiverDistrictNameLabel"),
            description: customer.districtName,
          ),
          IconTile(
            icon: Icon(null),
            title: localizations!
                .translate("nhDocPageReceiverCertificateAbNrLabel"),
            description: customer.certificateAbNr,
          ),
        ],
      );
    }

    Widget signature() {
      return Column(
        children: [
          sectionTitle(
            localizations!.translate("nhDocPageSignatureSectionTitle"),
          ),
          IconTile(
            icon: Icon(Icons.event),
            title: localizations!
                .translate("nhDocPageSignatureSignatureDateFieldLabel"),
            description: "", // Intentionally blank
          ),
          IconTile(
            icon: Icon(Icons.edit),
            title: localizations!
                .translate("nhDocPageSignatureSignatureFieldLabel"),
            description: "", // Intentionally blank
          ),
        ],
      );
    }

    Widget footnote() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          localizations!.translate("nhDocPageFootnote"),
          style: DccTextStyles.nhDoc.footNote,
        ),
      );
    }

    Widget transporterSection() {
      return BlocSubStateBuilder<TransporterCubit, TransporterState,
          TransporterLoaded>(
        subStateBuilder: (context, transporterState) {
          return BlocSubStateBuilder<CarCubit, CarState, CarLoaded>(
            subStateBuilder: (context, carState) {
              return transporter(transporterState.transporter, carState.car);
            },
            fallbackBuilder: (context, state) => loading(),
          );
        },
        fallbackBuilder: (context, state) => loading(),
      );
    }

    Widget nhDocDisplay(Pickup pickup) {
      return ListView(
        children: [
          title(),
          Divider(),
          date(pickup.deadline),
          Divider(),
          referenceNumber(),
          Divider(),
          category(pickup),
          cateogry3Extra(),
          Divider(),
          amountOrWeight(
              pickup.actualAmount != null
                  ? pickup.actualAmount.toString()
                  : pickup.amount.toString(),
              pickup.actualRegisteredWeight),
          finalDispositionType(pickup.actualFinalDisposition != null
              ? pickup.actualFinalDisposition
              : pickup.finalDisposition),
          Divider(),
          origin(pickup.originCustomer!),
          Divider(),
          transporterSection(),
          Divider(),
          receiver(pickup.receiverCustomer!),
          Divider(),
          signature(),
          Divider(),
          footnote(),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            navigator.pop();
          },
        ),
      ),
      body: BlocSubStateBuilder<PickupsCubit, PickupsState, PickupsLoaded>(
        subStateBuilder: (context, state) => nhDocDisplay(state.pickup),
        fallbackBuilder: (context, state) => loading(),
      ),
    );
  }
}
