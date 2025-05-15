import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoNotifier extends StateNotifier<List<String>> {
  TodoNotifier() : super([]);
  void main(String task) {
    if (task.isNotEmpty) {
      state = [...state, task];
    }
  }

  void remove(int index) {
    final update = [...state]..removeAt(index);
    state = update;
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<String>>(
  (ref) => TodoNotifier(),
);
