import 'package:cloud_firestore/cloud_firestore.dart';

class TitleModel {
  final String title;
  final String docId;
  final DateTime time;

  TitleModel({required this.title, required this.docId, required this.time});

  factory TitleModel.fromMap(Map<String, dynamic> map, String id) {
    return TitleModel(
      title: map['title'] as String,
      docId: id,
      time: (map['time'] as Timestamp).toDate(),
    );
  }
}
