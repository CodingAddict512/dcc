import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreHelper {
  static const String FIRESTORE_INSTANCE_NAME = "DCC";

  static FirebaseFirestore? instance;

  static Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = instance!.doc(path);
    if (merge) {
      return await reference.update(data);
    }
    return await reference.set(data);
  }

  static Future<void> deleteData({required String path}) async {
    final reference = instance!.doc(path);
    await reference.delete();
  }

  // static Stream<List<T>> collectionStream<T>({
  //   required String path,
  //   required T builder(Map<String, dynamic> data, String documentID),
  //   Query queryBuilder(Query query),
  //   int sort(T lhs, T rhs),
  // }) {
  //   Query query = instance!.collection(path);
  //   query = queryBuilder(query);
  //   final Stream<QuerySnapshot> snapshots = query.snapshots();
  //   return snapshots.map((snapshot) {
  //     // final result = snapshot.docs
  //     //     .map((snapshot) => builder(snapshot.data(), snapshot.id))
  //     //     .where((value) => value != null)
  //     //     .toList();
  //     final result = snapshot.docs
  //         .map((snapshot) {
  //           final data = snapshot.data()
  //               as Map<String, dynamic>?; // Safely cast to Map<String, dynamic>
  //           if (data == null) return null; // Handle null case
  //           return builder(
  //               data, snapshot.id); // Call builder with the safely casted data
  //         })
  //         .where((value) => value != null) // Filter out null values
  //         .toList(); // Cast to the expected type if necessary

  //     result.sort(sort);
  //     return result;
  //   });
  // }

  static Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
    required Query Function(Query query) queryBuilder, // Marked as required
    required int Function(T lhs, T rhs) sort, // Marked as required
  }) {
    Query query = instance!.collection(path);
    query = queryBuilder(query);
    final Stream<QuerySnapshot> snapshots = query.snapshots();

    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) {
            final data = snapshot.data()
                as Map<String, dynamic>?; // Safely cast to Map<String, dynamic>
            if (data == null) return null; // Handle null case
            return builder(
                data, snapshot.id); // Call builder with the safely casted data
          })
          .whereType<T>() // Filter out null values
          .toList(); // This will be of type List<T>

      result.sort(sort); // Sorting
      return result; // Returning List<T>
    });
  }

  static Stream<T> documentStream<T>({
    required String path,
    required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = instance!.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    // return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
    return snapshots.map((snapshot) {
      final data = snapshot.data()
          as Map<String, dynamic>?; // Safely cast to Map<String, dynamic>
      return builder(data!, snapshot.id);
    });
  }
}
