import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String text;
  final String id;
  final bool isDone;
  final DateTime? createdAt;
  final String? tag;
  final String? priority;

  Todo({
    required this.text,
    this.isDone = false,
    required this.id,
    this.createdAt,
    this.tag,
    this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isDone': isDone,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'tag': tag,
      'priority': priority,
    };
  }

  factory Todo.fromMap(String id, Map<String, dynamic> data) {
    return Todo(
      id: id,
      text: data['text'] ?? '',
      isDone: data['isDone'] ?? false,
      createdAt:
          data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : null,
      tag: data['tag'],
      priority: data['priority'],
    );
  }

  Todo toggle() => Todo(text: text, id: id, isDone: !isDone);
}
