import 'package:cloud_firestore/cloud_firestore.dart';

extension EmptyReference on DocumentReference {
  Future<bool> exists() async {
    try {
      // Use cache if possible.  If it is in the cache, then it is
      // sufficient.  If it is missing, then it will throw an exception
      // and we will fallback to attempting to contact the server.
      //
      // This has the advantage of avoiding an unnecessary read.
      final snapshot = await this.get(GetOptions(source: Source.cache));
      return snapshot.exists;
    } catch (e) {
      final snapshot = await this.get();
      return snapshot.exists;
    }
  }
}
