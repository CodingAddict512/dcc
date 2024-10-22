import 'dart:io';

import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/cubits/states/external_nh_doc_state.dart';
import 'package:dcc/data/respository_interface.dart';
import 'package:dcc/models/file_format.dart';
import 'package:dcc/models/pickup.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

const maxSize = 4 * 1024 * 1024;

class ExternalNhDocCubit extends Cubit<ExternalNhDocState> {
  final IRepository repository;
  final PickupsCubit pickupsCubit;

  ExternalNhDocCubit({@required this.repository, @required this.pickupsCubit}) : super(ExternalNhDocInitial());

  factory ExternalNhDocCubit.fromContext(BuildContext context) => ExternalNhDocCubit(
    pickupsCubit: context.read<PickupsCubit>(),
    repository: context.read<IRepository>(),
  );


  Future<void> uploadNhDocImage(File file, Pickup pickup) async {
    try {
      final ext = p.extension(file.path);
      int length = await file.length();
      if (length >= maxSize) {
        // We deliberately use .ceil vs. .floor to ensure the error message
        // always make sizeInKb seem at least as large as maxSizeInKb if there
        // is an issue (i.e. rounding will never cause a message to say
        // that sizeInKb is smaller than maxSizeInKb).
        final sizeInKb = (length / 1024).ceil();
        final maxSizeInKb = (maxSize / 1024).floor();
        // FIXME: Need better translation support (we cannot do parameterized
        // translations at the moment).
        final error = ExternalNhDocUploadError(message: "File is too large - must be smaller than $maxSizeInKb Kb, but is $sizeInKb Kb");
        emit(error);
        return;
      }

      await repository.uploadNhDocImage(file, pickup.driverId, pickup.id);
      pickupsCubit.registerNhDocFormat(FileFormatHelper.fromExtension(ext));
      final loaded = ExternalNhDocDownloaded(file: file);
      emit(loaded);
      await this._loadImage(file, pickup);
    } on FirebaseException catch (e) {
      emit(ExternalNhDocUploadError(message: e.message));
    }
  }

  Future<void> _loadImage(File file, Pickup pickup) async {
    final bytes = await file.readAsBytes();
    final image = MemoryImage(bytes);
    final loaded = ExternalNhDocLoadedInMemory(file: file, memoryImage: image);
    emit(loaded);
  }

  Future<void> downloadNhDocImage(Pickup pickup) async {
    try {
      emit(ExternalNhDocLoading());
      final ext = FileFormatHelper.toExtension(pickup.externalNHDocFormat);

      File file = await repository.downloadNhDocImage(pickup.driverId, pickup.id, ext);
      final downloaded = ExternalNhDocDownloaded(file: file);
      emit(downloaded);
      await this._loadImage(file, pickup);
    } on FirebaseException catch (e) {
      emit(ExternalNhDocDownloadError(message: e.message));
    }
  }
}
