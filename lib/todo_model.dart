class Todo {
  final String text;
  final String id;
  final bool isDone;

  Todo({required this.text, this.isDone = false, required this.id});
  Map<String, dynamic> toMap() {
    return {'text': text, 'isDone': isDone};
  }

  factory Todo.fromMap(String id, Map<String, dynamic> data) {
    return Todo(text: data['text'], id: id, isDone: data['isDone'] ?? false);
  }

  Todo toggle() => Todo(text: text, id: id, isDone: !isDone);
}
