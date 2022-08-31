import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class Utils {
  static StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<T>>
      transformer<T>(T Function(Map<String, dynamic> json) fromJson) {
    return StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
        List<T>>.fromHandlers(
      handleData:
          (QuerySnapshot<Map<String, dynamic>> data, EventSink<List<T>> sink) {
        final snaps = data.docs.map((doc) => doc.data()).toList();
        data.docs.forEachIndexed((index, doc) {
          snaps[index]["id"] = doc.id;
        });
        final users = snaps.map((json) => fromJson(json)).toList();

        sink.add(users);
      },
    );
  }

  static DateTime? toDateTime(Timestamp value) {
    // ignore: unnecessary_null_comparison
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    // ignore: unnecessary_null_comparison
    if (date == null) return null;

    return date.toUtc();
  }

  static List<dynamic> fromQuerySnapshotToObjects(
      QuerySnapshot<Map<String, dynamic>> snapshot,
      Function(Map<String, dynamic> json) fromJson) {
    final snaps = snapshot.docs.map((doc) => doc.data()).toList();
    snapshot.docs.forEachIndexed((index, doc) {
      snaps[index]["id"] = doc.id;
    });
    final objects = snaps.map((json) => fromJson(json)).toList();

    return objects;
  }
}
