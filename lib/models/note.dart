import 'package:notes_app/constants/values.dart';

class Note {
  String title;
  String body;
  String id;
  List<String> labels;
  String color;
  DateTime createdAt;
  DateTime modifiedAt;
  bool pinned;
  bool archived;
  Note(
      {this.title,
      this.body,
      this.labels,
      this.color,
      this.createdAt,
      this.modifiedAt,
      this.pinned,
      this.id,
      this.archived});
}
