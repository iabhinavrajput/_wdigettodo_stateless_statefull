import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:todo/todo_model.dart';
import 'package:todo/todo_notifier.dart';
import 'package:todo/auth_provider.dart';

class TodoApp extends ConsumerStatefulWidget {
  const TodoApp({super.key});

  @override
  ConsumerState<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends ConsumerState<TodoApp> {
  final TextEditingController _controller = TextEditingController();
  bool _isAdding = false;

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final todosAsync = ref.watch(todoListProvider);
    final todoController = ref.read(todoControllerProvider);
    final auth = ref.read(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Tasks",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black54),
            onPressed: () async {
              await auth.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Input Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
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
                        hintText: 'What do you need to do?',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () async {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        setState(() => _isAdding = true);
                        await todoController.addTodo(text);
                        setState(() {
                          _isAdding = false;
                          _controller.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          // Todo List
          Expanded(
            child: todosAsync.when(
              data: (todos) {
                final reversedTodos = todos.reversed.toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: reversedTodos.length + (_isAdding ? 1 : 0),
                  itemBuilder: (_, index) {
                    // Optimistic shimmer at top
                    if (_isAdding && index == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: const CircularProgressIndicator(),
                            title: Container(
                              height: 16,
                              width: double.infinity,
                              color: Colors.grey[300],
                            ),
                            subtitle: Container(
                              height: 12,
                              width: 100,
                              margin: const EdgeInsets.only(top: 8),
                              color: Colors.grey[200],
                            ),
                          ),
                        ),
                      );
                    }

                    final todo = reversedTodos[_isAdding ? index - 1 : index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          leading: Checkbox(
                            value: todo.isDone,
                            activeColor: Colors.blueAccent,
                            onChanged: (_) => todoController.toggleTodo(todo),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todo.text,
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: todo.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: todo.isDone
                                      ? Colors.grey
                                      : Colors.black87,
                                ),
                              ),
                              if (todo.createdAt != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Added on ${_formatDate(todo.createdAt!)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
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
                  'Error loading todos.',
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
