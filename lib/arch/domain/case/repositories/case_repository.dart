import 'package:dartz/dartz.dart';

import '../../core/value_objects.dart';
import '../../location/entities/location.dart';
import '../entities/case.dart';
import '../enums/case_status.dart';
import '../failures/failure.dart';
import '../value_objects/value_object.dart';

abstract class CaseRepository {
  Future<Either<CaseFailure, UniqueId>> createCase(Location location,
      CaseTitle title,
      CaseDescription description,
      CaseAddress address,
      List3<CaseLocalPhoto> photos);

  Future<Either<CaseFailure, Case>> getCase(UniqueId id);

  Stream<List<Case>> nearByCaseStream(Location myLocation, double radius);

  Future<Either<CaseFailure, Unit>> resolveCase(Case caze);

  Future<Either<CaseFailure, Unit>> deleteCase(Case caze);

  Future<CaseStatus> getCaseStatus(UniqueId caseId);
}
