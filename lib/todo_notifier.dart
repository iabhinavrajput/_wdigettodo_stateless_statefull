import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/todo_model.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);

  void add(String text) {
    if (text.isNotEmpty) {
      state = [...state, Todo(text: text)];
    }
  }

  void remove(int index) {
    final updated = [...state]..removeAt(index);
    state = updated;
  }

  void toggleDone(int index) {
    final updated = [...state];
    updated[index] = updated[index].toogleDone();
    state = updated;
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>(
  (ref) => TodoNotifier(),
);
