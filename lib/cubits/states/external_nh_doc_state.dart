// import 'dart:io';

// import 'package:dcc/cubits/states/base_state.dart';
// import 'package:flutter/widgets.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'external_nh_doc_state.freezed.dart';

// @immutable
// abstract class ExternalNhDocState extends BaseState {
//   const ExternalNhDocState();
// }

// @freezed
// abstract class ExternalNhDocInitial extends ExternalNhDocState with _$ExternalNhDocInitial {
//   ExternalNhDocInitial._();

//   factory ExternalNhDocInitial() = _ExternalNhDocInitial;
// }

// @freezed
// abstract class ExternalNhDocLoading extends ExternalNhDocState with _$ExternalNhDocLoading {
//   ExternalNhDocLoading._();

//   factory ExternalNhDocLoading() = _ExternalNhDocLoading;
// }

// @freezed
// abstract class ExternalNhDocDownloaded extends ExternalNhDocState with _$ExternalNhDocDownloaded {
//   ExternalNhDocDownloaded._();

//   factory ExternalNhDocDownloaded({
//     final File file,
//   }) = _ExternalNhDocDownloaded;
// }

// @freezed
// abstract class ExternalNhDocLoadedInMemory extends ExternalNhDocState with _$ExternalNhDocLoadedInMemory {
//   ExternalNhDocLoadedInMemory._();

//   factory ExternalNhDocLoadedInMemory({
//     final File file,
//     final MemoryImage memoryImage,
//   }) = _ExternalNhDocLoadedInMemory;
// }

// @immutable
// abstract class ExternalNhDocError extends ExternalNhDocState {
//   const ExternalNhDocError();

//   get message;
// }

// @freezed
// abstract class ExternalNhDocDownloadError extends ExternalNhDocError with _$ExternalNhDocDownloadError {
//   ExternalNhDocDownloadError._();

//   factory ExternalNhDocDownloadError({
//     final String message,
//   }) = _ExternalNhDocDownloadError;
// }

// @freezed
// abstract class ExternalNhDocUploadError extends ExternalNhDocError with _$ExternalNhDocUploadError {
//   ExternalNhDocUploadError._();

//   factory ExternalNhDocUploadError({
//     final String message,
//   }) = _ExternalNhDocUploadError;
// }

import 'dart:io';
import 'package:dcc/cubits/states/base_state.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class ExternalNhDocState extends BaseState {
  const ExternalNhDocState();
}

class ExternalNhDocInitial extends ExternalNhDocState {
  const ExternalNhDocInitial();
}

class ExternalNhDocLoading extends ExternalNhDocState {
  const ExternalNhDocLoading();
}

class ExternalNhDocDownloaded extends ExternalNhDocState {
  final File file;

  const ExternalNhDocDownloaded({
    required this.file,
  });

  ExternalNhDocDownloaded copyWith({
    File? file,
  }) {
    return ExternalNhDocDownloaded(
      file: file ?? this.file,
    );
  }
}

class ExternalNhDocLoadedInMemory extends ExternalNhDocState {
  final File file;
  final MemoryImage memoryImage;

  const ExternalNhDocLoadedInMemory({
    required this.file,
    required this.memoryImage,
  });

  ExternalNhDocLoadedInMemory copyWith({
    File? file,
    MemoryImage? memoryImage,
  }) {
    return ExternalNhDocLoadedInMemory(
      file: file ?? this.file,
      memoryImage: memoryImage ?? this.memoryImage,
    );
  }
}

@immutable
abstract class ExternalNhDocError extends ExternalNhDocState {
  final String message;

  const ExternalNhDocError(this.message);
}

class ExternalNhDocDownloadError extends ExternalNhDocError {
  const ExternalNhDocDownloadError({
    required String message,
  }) : super(message);
}

class ExternalNhDocUploadError extends ExternalNhDocError {
  const ExternalNhDocUploadError({
    required String message,
  }) : super(message);
}
