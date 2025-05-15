import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoApp(),
    );
  }
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final List<String> _todos = [];
  final _controller = TextEditingController();

  void _addTodos() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todos.add(_controller.text);
      });
      _controller.clear();
    }
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To-Do List")),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextField(controller: _controller)),
              IconButton(onPressed: _addTodos, icon: Icon(Icons.add),

              ),
              
            ],
          ),
          Expanded(child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (_, index) => ListTile(
                  title: Text(_todos[index]),
                  trailing: IconButton(onPressed: () => _removeTodo(index), icon: Icon(Icons.delete)),
                ),
              ))
        ],
      ),
    );
  }
}
