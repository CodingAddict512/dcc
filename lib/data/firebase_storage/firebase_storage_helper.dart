import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageHelper {
  static FirebaseStorage? instance;

  static Future<TaskSnapshot> uploadFile(File file, String toPath) async {
    return await instance!.ref(toPath).putFile(file);
  }

  static Future<File> downloadFile(String fromPath) async {
    Directory tempDir = await getTemporaryDirectory();
    File downloadToFile = File('${tempDir.path}/dcc/${fromPath}');
    await downloadToFile.create(recursive: true);

    await instance!.ref(fromPath).writeToFile(downloadToFile);

    return downloadToFile;
  }
}
