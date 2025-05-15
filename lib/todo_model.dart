class Todo {
  final String text;
  final bool isDone;
  Todo({required this.text, this.isDone = false});
  Todo toogleDone() => Todo(text: text, isDone: !isDone);
}
