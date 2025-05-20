import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String text;
  final String id;
  final bool isDone;
  final DateTime? createdAt;

  Todo({
    required this.text,
    this.isDone = false,
    required this.id,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {'text': text, 'isDone': isDone, 'createdAt': createdAt};
  }

  factory Todo.fromMap(String id, Map<String, dynamic> data) {
    return Todo(
      id: id,
      text: data['text'] ?? '',
      isDone: data['isDone'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Todo toggle() => Todo(text: text, id: id, isDone: !isDone);
}
