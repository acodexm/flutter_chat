import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat/core/models/cloud_storage/cloud_storage.dart';
import 'package:flutter_chat/utils/logger.dart';

enum BucketPath { PROFILE, EVENT, MESSAGE }

abstract class CloudStorageService {
  Future<CloudStorageResult> uploadFile(
      {@required File imageToUpload, @required BucketPath path});

  double get progress;

  bool get isCompleted;

  Future deleteFile(
      {@required String imageFileName, @required BucketPath path});
}

class CloudStorageServiceImpl implements CloudStorageService {
  final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref();
  bool _isCompleted = false;

  bool get isCompleted => _isCompleted;
  double _progress;

  double get progress => _progress;

  Future<CloudStorageResult> uploadFile(
      {@required File imageToUpload, @required BucketPath path}) async {
    var imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference bucket = _getFolder(path).child(imageFileName);
    try {
      StorageUploadTask uploadTask = bucket.putFile(imageToUpload);
      uploadTask.events.listen((event) {
        _progress =
            event.snapshot.bytesTransferred / event.snapshot.totalByteCount;
      });
      StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
      var downloadUrl = await storageSnapshot.ref.getDownloadURL();
      _isCompleted = uploadTask.isComplete;
      if (_isCompleted) {
        return CloudStorageResult(
          imageUrl: downloadUrl.toString(),
          imageFileName: imageFileName,
        );
      }
    } catch (e) {
      Log.e('upload file failed', e: e);
    }
    return null;
  }

  Future<bool> deleteFile(
      {@required String imageFileName, @required BucketPath path}) async {
    final StorageReference bucket = _getFolder(path).child(imageFileName);
    try {
      await bucket.delete();
      return true;
    } catch (e) {
      Log.e('Delete file error', e: e);
      return false;
    }
  }

  StorageReference _getFolder(BucketPath path) {
    switch (path) {
      case BucketPath.EVENT:
        {
          return firebaseStorageRef.child('events');
        }
      case BucketPath.MESSAGE:
        {
          return firebaseStorageRef.child('messages');
        }
      case BucketPath.PROFILE:
        {
          return firebaseStorageRef.child('profile');
        }
      default:
        {
          return firebaseStorageRef;
        }
    }
  }
}
