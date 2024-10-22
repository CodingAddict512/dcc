import 'dart:io';

import 'package:dcc/cubits/states/base_state.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'external_nh_doc_state.freezed.dart';

@immutable
abstract class ExternalNhDocState extends BaseState {
  const ExternalNhDocState();
}

@freezed
abstract class ExternalNhDocInitial extends ExternalNhDocState with _$ExternalNhDocInitial {
  ExternalNhDocInitial._();

  factory ExternalNhDocInitial() = _ExternalNhDocInitial;
}

@freezed
abstract class ExternalNhDocLoading extends ExternalNhDocState with _$ExternalNhDocLoading {
  ExternalNhDocLoading._();

  factory ExternalNhDocLoading() = _ExternalNhDocLoading;
}

@freezed
abstract class ExternalNhDocDownloaded extends ExternalNhDocState with _$ExternalNhDocDownloaded {
  ExternalNhDocDownloaded._();

  factory ExternalNhDocDownloaded({
    final File file,
  }) = _ExternalNhDocDownloaded;
}

@freezed
abstract class ExternalNhDocLoadedInMemory extends ExternalNhDocState with _$ExternalNhDocLoadedInMemory {
  ExternalNhDocLoadedInMemory._();

  factory ExternalNhDocLoadedInMemory({
    final File file,
    final MemoryImage memoryImage,
  }) = _ExternalNhDocLoadedInMemory;
}

@immutable
abstract class ExternalNhDocError extends ExternalNhDocState {
  const ExternalNhDocError();

  get message;
}

@freezed
abstract class ExternalNhDocDownloadError extends ExternalNhDocError with _$ExternalNhDocDownloadError {
  ExternalNhDocDownloadError._();

  factory ExternalNhDocDownloadError({
    final String message,
  }) = _ExternalNhDocDownloadError;
}

@freezed
abstract class ExternalNhDocUploadError extends ExternalNhDocError with _$ExternalNhDocUploadError {
  ExternalNhDocUploadError._();

  factory ExternalNhDocUploadError({
    final String message,
  }) = _ExternalNhDocUploadError;
}
