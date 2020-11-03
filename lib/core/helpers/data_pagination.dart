import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/utils/logger.dart';

class DataPagination {
  final StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get streamData => _streamController.stream;

  bool _hasMoreData = true;
  bool _isFirstCall = true;

  List<List<DocumentSnapshot>> _allPagedData = List<List<DocumentSnapshot>>();

  DocumentSnapshot _lastDoc;
  List<StreamSubscription> _realTimeUpdates = [];

  void refreshPage(Query query, int limit) {
    disposePagination();
    requestPaginatedData(query, limit);
  }

  Future<DocumentSnapshot> _firstCall(Query query, int limit) async {
    if (_isFirstCall) {
      QuerySnapshot snapshot = await query.limit(limit).get();
      if (snapshot.docs.isNotEmpty) return snapshot.docs.last;
    }
    return Future.value(null);
  }

  Future<void> requestPaginatedData(Query query, int limit) async {
    //todo handle no data
    DocumentSnapshot _endAtDocument = await _firstCall(query, limit);
    Query pageQuery = query;
    if (_endAtDocument != null) {
      pageQuery = pageQuery.endAtDocument(_endAtDocument);
      _isFirstCall = false;
    } else {
      pageQuery = pageQuery.limit(limit);
    }
    if (_lastDoc != null) {
      pageQuery = pageQuery.startAfterDocument(_lastDoc);
    }
    if (!_hasMoreData) return;
    int currentRequestIndex = _allPagedData.length;

    Log.d('new listener $currentRequestIndex');
    _realTimeUpdates.add(
      pageQuery
          .snapshots()
          .where((snap) => !snap.metadata.hasPendingWrites)
          .map((snap) => snap.docs)
          .listen(
        (docs) {
          Log.d('update on listener $currentRequestIndex');
          if (docs.isEmpty) return;
          if (currentRequestIndex < _allPagedData.length) {
            _allPagedData[currentRequestIndex] = docs;
          } else {
            _allPagedData.add(docs);
          }
          _streamController.add(_allPagedData.fold<List<DocumentSnapshot>>(
              List<DocumentSnapshot>(),
              (initialValue, pageItems) => initialValue..addAll(pageItems)));
          if (currentRequestIndex == _allPagedData.length - 1) {
            _lastDoc = docs.last;
          }
          _hasMoreData = docs.length == limit;
        },
      ),
    );
  }

  void disposePagination() {
    _realTimeUpdates?.forEach((element) {
      element?.cancel();
    });
    _realTimeUpdates.clear();
    _allPagedData.clear();
    _lastDoc = null;
    _isFirstCall = true;
    _hasMoreData = true;
  }
}
