import 'package:flutter/material.dart';

class DccTextStyles {
  static const _PickupCard pickupCard = _PickupCard(
    title: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    status: TextStyle(
      color: Colors.blueAccent,
    ),
    deadline: TextStyle(
      color: Colors.grey,
    ),
    weight: TextStyle(),
    type: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  );

  static const _PickupGroup pickupGroup = _PickupGroup(
    title: TextStyle(),
  );

  static const _PickupFab pickupFab = _PickupFab(
    label: TextStyle(
      color: Colors.black,
    ),
  );

  static const _PickupEdit pickupEdit = _PickupEdit(
    title: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    toFrom: TextStyle(
      color: Colors.grey,
    ),
  );

  static const _PickupRouteCreate pickupRouteCreate = _PickupRouteCreate(
    title: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  );

  static const _PickupDetails pickupDetails = _PickupDetails(
    title: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    status: TextStyle(
      color: Colors.blueAccent,
      fontWeight: FontWeight.bold,
    ),
    pickupId: TextStyle(
      color: Colors.grey,
      fontStyle: FontStyle.italic,
    ),
    customerId: TextStyle(
      color: Colors.grey,
      fontStyle: FontStyle.italic,
    ),
    customerNotes: TextStyle(
      color: Colors.deepOrangeAccent,
    ),
  );

  static const _IconTile iconTile = _IconTile(
    title: TextStyle(
      fontSize: 12,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
    ),
    description: TextStyle(),
  );

  static const _NhDoc nhDoc = _NhDoc(
    mainTitle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    sectionTitle: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    footNote: TextStyle(
      color: Colors.grey,
      fontSize: 13,
    ),
  );
}

class _PickupCard {
  const _PickupCard({
    required this.title,
    required this.status,
    required this.deadline,
    required this.weight,
    required this.type,
  });

  final TextStyle title;
  final TextStyle status;
  final TextStyle deadline;
  final TextStyle weight;
  final TextStyle type;
}

class _PickupGroup {
  const _PickupGroup({
    required this.title,
  });

  final TextStyle title;
}

class _PickupFab {
  const _PickupFab({
    required this.label,
  });

  final TextStyle label;
}

class _PickupEdit {
  const _PickupEdit({required this.title, required this.toFrom});

  final TextStyle title;
  final TextStyle toFrom;
}

class _PickupRouteCreate {
  const _PickupRouteCreate({required this.title});

  final TextStyle title;
}

class _PickupDetails {
  const _PickupDetails({
    required this.title,
    required this.status,
    required this.pickupId,
    required this.customerId,
    required this.customerNotes,
  });

  final TextStyle title;
  final TextStyle status;
  final TextStyle pickupId;
  final TextStyle customerId;
  final TextStyle customerNotes;
}

class _IconTile {
  const _IconTile({
    required this.title,
    required this.description,
  });

  final TextStyle title;
  final TextStyle description;
}

class _NhDoc {
  const _NhDoc({
    required this.mainTitle,
    required this.sectionTitle,
    required this.footNote,
  });

  final TextStyle mainTitle;
  final TextStyle sectionTitle;
  final TextStyle footNote;
}
