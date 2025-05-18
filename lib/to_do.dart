import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:todo/todo_model.dart';
import 'package:todo/todo_notifier.dart';
import 'package:todo/auth_provider.dart';

class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoListProvider);
    final todoController = ref.read(todoControllerProvider);
    final auth = ref.read(authControllerProvider);
    final _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do with Firestore & Riverpod"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: auth.signOut),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Enter a todo'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      todoController.addTodo(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: todosAsync.when(
              data:
                  (todos) => ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (_, index) {
                      final todo = todos[index];
                      return ListTile(
                        leading: Checkbox(
                          value: todo.isDone,
                          onChanged: (_) => todoController.toggleTodo(todo),
                        ),
                        title: Text(
                          todo.text,
                          style: TextStyle(
                            decoration:
                                todo.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => todoController.deleteTodo(todo.id),
                        ),
                      );
                    },
                  ),
              loading:
                  () => Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.black,
                      size: 200,
                    ),
                  ),
              error:
                  (e, _) => Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
