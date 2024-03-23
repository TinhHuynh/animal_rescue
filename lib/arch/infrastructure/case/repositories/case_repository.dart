import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/case/entities/case.dart';
import '../../../domain/case/enums/case_status.dart';
import '../../../domain/case/failures/failure.dart';
import '../../../domain/case/repositories/case_repository.dart';
import '../../../domain/case/value_objects/value_object.dart';
import '../../../domain/core/value_objects.dart';
import '../../../domain/location/entities/location.dart';
import '../../core/firebase/auth_helper.dart';
import '../../core/firebase/firestore_helper.dart';
import '../../core/firebase/storage_helper.dart';
import '../../location/dtos/location_dto.dart';
import '../dtos/case_dto.dart';

@Injectable(as: CaseRepository)
class CaseRepositoryImpl implements CaseRepository {
  final StorageHelper _storageHelper;
  final FirestoreHelper _firestoreHelper;
  final AuthHelper _authHelper;

  CaseRepositoryImpl(
      this._firestoreHelper, this._storageHelper, this._authHelper);

  @override
  Future<Either<CaseFailure, UniqueId>> createCase(
      Location location,
      CaseTitle title,
      CaseDescription description,
      CaseAddress address,
      List3<CaseLocalPhoto> photos) async {
    try {
      UniqueId uniqueId = UniqueId();
      final id = uniqueId.getOrCrash();
      await _uploadPhoto(id, photos);
      await _uploadContent(id, title, description, address, location);
      return right(uniqueId);
    } on UnableToUploadFileException {
      return left(const CaseFailure.failedToCreateCase());
    } on UnableToCreateCase {
      return left(const CaseFailure.failedToCreateCase());
    }
  }

  Future<void> _uploadPhoto(String uid, List3<CaseLocalPhoto> photos) async {
    try {
      final uploadPhotos =
          photos.getOrCrash().map((e) => File(e.getOrCrash())).toList();
      await _storageHelper.uploadCasePhotos(uploadPhotos, uid);
    } on UnableToUploadFileException {
      rethrow;
    }
  }

  _uploadContent(String id, CaseTitle title, CaseDescription description,
      CaseAddress address, Location location) {
    try {
      final userId = _authHelper.getUserId();
      if (userId == null) return;
      _firestoreHelper.createCase(CaseDto(
          id: id,
          userid: userId,
          title: title.getOrCrash(),
          description: description.getOrCrash(),
          address: address.getOrCrash(),
          locationPoint: LocationPoint.fromLatitudeLongitude(
              location.latitude.getOrCrash(), location.longitude.getOrCrash()),
          status: CaseStatus.active));
    } on UnableToCreateCase {
      rethrow;
    }
  }

  @override
  Future<Either<CaseFailure, Case>> getCase(UniqueId id) async {
    try {
      CaseDto dto = await _firestoreHelper.getCase(id.getOrCrash());
      final photos = await _getCasePhotos(id);
      return right(dto.toDomain(List3(photos)));
    } on UnableToGetCase {
      return left(const CaseFailure.failedToLoadCase());
    } on UnableToGetImageUrlException {
      return left(const CaseFailure.failedToLoadCase());
    }
  }

  Future<List<Url>> _getCasePhotos(UniqueId id) async {
    List<String> imageUrls =
        await _storageHelper.getCasePhotos(id.getOrCrash());
    return imageUrls.map((e) => Url(e)).toList();
  }

  @override
  Stream<List<Case>> nearByCaseStream(Location myLocation, double radius) {
    StreamController<List<Case>> controller = StreamController();
    _firestoreHelper
        .getNearByCasesAt(LocationDto.fromDomain(myLocation), radius)
        .listen((event) async {
      List<Case> items = [];
      final nonNulls = event.where((element) => element != null);
      for (var element in nonNulls) {
        final caze = element!.toDomain(
            List3(await _getCasePhotos(UniqueId.fromUniqueString(element.id))));
        items.add(caze);
      }
      controller.sink.add(items);
    });
    return controller.stream;
  }

  @override
  Future<Either<CaseFailure, Unit>> deleteCase(Case caze) async {
    try {
      await _firestoreHelper.updateCaseStatus(
          caze.id.getOrCrash(), CaseStatus.deleted);
      return right(unit);
    } on UnableToUpdateCase {
      return left(const CaseFailure.failedToDeleteCase());
    }
  }

  @override
  Future<Either<CaseFailure, Unit>> resolveCase(Case caze) async {
    try {
      await _firestoreHelper.updateCaseStatus(
          caze.id.getOrCrash(), CaseStatus.resolved);
      return right(unit);
    } on UnableToUpdateCase {
      return left(const CaseFailure.failedToResolveCase());
    }
  }

  @override
  Future<CaseStatus> getCaseStatus(UniqueId caseId) {
    return _firestoreHelper.getCaseStatus(caseId.getOrCrash());
  }
}
