import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/todo_model.dart';
import 'package:todo/todo_notifier.dart';
import 'package:todo/auth_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TodoApp extends ConsumerStatefulWidget {
  const TodoApp({super.key});

  @override
  ConsumerState<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends ConsumerState<TodoApp> {
  final TextEditingController _controller = TextEditingController();

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final todosAsync = ref.watch(todoListProvider);
    final todoController = ref.read(todoControllerProvider);
    final auth = ref.read(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Daily Tasks",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black54),
            onPressed: () => auth.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Input
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add a new task...",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blueAccent),
                    onPressed: () async {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        await todoController.addTodo(text);
                        _controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          // Task list
          Expanded(
            child: todosAsync.when(
              data: (todos) {
                final sortedTodos = todos
                    .where((t) => t.createdAt != null)
                    .toList()
                  ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

                if (sortedTodos.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks yet. Start by adding one!',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: sortedTodos.length,
                  itemBuilder: (_, index) {
                    final todo = sortedTodos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        color: todo.isDone ? Colors.grey[200] : Colors.white,
                        child: ListTile(
                          leading: Checkbox(
                            value: todo.isDone,
                            activeColor: Colors.green,
                            onChanged: (_) => todoController.toggleTodo(todo),
                          ),
                          title: Text(
                            todo.text,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: todo.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: todo.isDone ? Colors.grey : Colors.black87,
                            ),
                          ),
                          subtitle: todo.createdAt != null
                              ? Text(
                                  'Added on ${_formatDate(todo.createdAt!)}',
                                  style: const TextStyle(fontSize: 12),
                                )
                              : null,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => todoController.deleteTodo(todo.id),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.blueAccent,
                  size: 50,
                ),
              ),
              error: (e, _) => const Center(
                child: Text(
                  'Something went wrong!',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
