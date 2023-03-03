import 'dart:async';

import 'package:animal_rescue/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import '../../../domain/case/enums/case_status.dart';
import '../../auth/dtos/user_dto.dart';
import '../../case/dtos/case_dto.dart';
import '../../chat/dtos/message_dto.dart';
import '../../location/dtos/location_dto.dart';

class FirestoreHelper {
  static final instance = FirestoreHelper(FirebaseFirestore.instance);

  final FirebaseFirestore _db;

  FirestoreHelper(this._db);

  CollectionReference get _usersCollection => _db.collection('users');

  CollectionReference get _casesCollection => _db.collection('cases');

  CollectionReference _chatsCollection(String caseId) =>
      _db.collection('chats/$caseId/messages');

  createUser(UserDto user) async {
    try {
      await _usersCollection.doc(user.uid).set(user.toJson());
    } catch (e) {
      throw UnableToCreateUser();
    }
  }

  Future<UserDto> getUser(String id) async {
    try {
      final snap = await _usersCollection.doc(id).get();
      return UserDto.fromJson(snap.data() as Map<String, dynamic>);
    } catch (e) {
      throw UnableToCreateUser();
    }
  }

  createCase(CaseDto caze) async {
    try {
      await _casesCollection.doc(caze.id).set(caze.toJson());
    } catch (e) {
      throw UnableToCreateCase();
    }
  }

  Future<CaseDto> getCase(String id) async {
    try {
      final snap = await _casesCollection.doc(id).get();
      return CaseDto.fromJson(snap.data() as Map<String, dynamic>);
    } catch (e) {
      throw UnableToGetCase();
    }
  }

  Future updateCaseStatus(String id, CaseStatus status) async {
    try {
      await _casesCollection.doc(id).update({'status': status.name});
    } catch (e) {
      logger.d(e);
      throw UnableToUpdateCase();
    }
  }

  Stream<List<CaseDto?>> getNearByCasesAt(
      LocationDto myLocation, double radius) {
    GeoFirePoint center = GeoFirePoint(myLocation.lat, myLocation.long);
    double radius = 5;
    String field = 'location_point';

    return GeoFlutterFire()
        .collection(collectionRef: _casesCollection)
        .within(center: center, radius: radius, field: field)
        .map((event) => event.map((e) {
              if (e.data() == null) return null;
              return CaseDto.fromJson(e.data() as Map<String, dynamic>);
            }).toList());
  }

  Future<CaseStatus> getCaseStatus(String id) {
    try {
      return getCase(id).then((value) => value.status);
    } catch (e) {
      throw UnableToGetCase();
    }
  }

  createMessage(String caseId, MessageDto dto) async {
    try {
      await _chatsCollection(dto.caseId).doc(dto.id).set(dto.toJson());
    } catch (e) {
      logger.d(e);
      throw UnableToCreateMessage();
    }
  }

  Future<List<MessageDto>> getMessages(
      String caseId, int? beforeMillis, int page) async {
    try {
      var query =
          _chatsCollection(caseId).orderBy("created_date", descending: true);
      if (beforeMillis != null) {
        query = query
            .startAfter([Timestamp.fromMillisecondsSinceEpoch(beforeMillis)]);
      }
      query = query.limit(page);
      return await query.get().then((value) {
        return value.docs
            .map((e) => MessageDto.fromJson(e.data() as Map<String, dynamic>))
            .toList();
      }).catchError((_) => throw UnableToLoadMessages());
    } catch (e) {
      throw UnableToLoadMessages();
    }
  }

  Stream<MessageDto> getNewMessage(String caseId, int? afterMillis) {
    try {
      StreamController<MessageDto> controller = StreamController();
      var query =
          _chatsCollection(caseId).orderBy("created_date", descending: true);
      if (afterMillis != null) {
        query = query
            .endBefore([Timestamp.fromMillisecondsSinceEpoch(afterMillis)]);
      }
      query = query.limit(1);
      query.snapshots().forEach((element) {
        if (element.size > 0 &&
            _checkValidateNewMessage(
                element.docs.first.data() as Map<String, dynamic>)) {
          controller.sink.add(MessageDto.fromJson(
              element.docs.first.data() as Map<String, dynamic>));
        }
      });
      return controller.stream;
    } catch (e) {
      throw UnableToLoadMessages();
    }
  }

  bool _checkValidateNewMessage(Map<String, dynamic> data) {
    return data['created_date'] != null;
  }
}

class UnableToCreateUser implements Exception {}

class UnableToGetUser implements Exception {}

class UnableToCreateCase implements Exception {}

class UnableToGetCase implements Exception {}

class UnableToUpdateCase implements Exception {}

class UnableToCreateMessage implements Exception {}

class UnableToLoadMessages implements Exception {}
