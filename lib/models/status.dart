enum Status {
  DRAFT,
  ASSIGNED,
  STARTED,
  SUBMITTED,
  COLLECTED,
  REJECTED;

  // Convert Firestore string to Status
  static Status fromString(String status) {
    return Status.values.firstWhere(
        (e) => e.toString().split('.').last == status,
        orElse: () => Status.DRAFT);
  }

  // Convert Status to Firestore string
  String toFirestoreString() {
    return toString().split('.').last;
  }
}
