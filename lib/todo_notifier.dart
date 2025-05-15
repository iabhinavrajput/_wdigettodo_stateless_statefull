import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'todo_model.dart';
import 'todo_repository.dart';

final todoRepositoryProvider = Provider((ref) {
  return TodoRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
});

final todoListProvider = StreamProvider<List<Todo>>((ref) {
  return ref.watch(todoRepositoryProvider).getTodos();
});

final todoControllerProvider = Provider((ref) {
  return ref.watch(todoRepositoryProvider);
});
