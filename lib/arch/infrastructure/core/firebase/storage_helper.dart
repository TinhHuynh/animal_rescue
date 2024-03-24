import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class StorageHelper {

  Reference get _storageRef => FirebaseStorage.instance.ref();

  Reference get _avatarRef => _storageRef.child("images/avatars");

  Reference get _casePhotoRef => _storageRef.child("images/cases");

  StorageHelper();

  Future uploadAvatar(File file, String uid) async {
    final ref = _avatarRef.child("$uid/avatar");
    try {
      await ref.putFile(file);
    } on FirebaseException {
      throw UnableToUploadFileException();
    }
  }

  Future<String> getAvatarUrl(String uid) async {
    final ref = _avatarRef.child("$uid/avatar");
    try {
      return await ref.getDownloadURL();
    } on FirebaseException {
      throw UnableToGetImageUrlException();
    }
  }

  Future uploadCasePhotos(List<File> photos, String uid) async {
    try {
      for (var element in photos) {
        final ref =
            _casePhotoRef.child("$uid/${element.uri.pathSegments.last}");
        await ref.putFile(element);
      }
    } on FirebaseException {
      throw UnableToUploadFileException();
    }
  }

  Future<List<String>> getCasePhotos(String uid) async {
    final ref = _casePhotoRef.child(uid);
    try {
      final items = await ref.listAll();
      final urls = <String>[];
      for (var element in items.items) {
        urls.add(await element.getDownloadURL());
      }
      return urls;
    } on FirebaseException {
      throw UnableToGetImageUrlException();
    }
  }
}

class UnableToUploadFileException implements Exception {}

class UnableToGetImageUrlException implements Exception {}
