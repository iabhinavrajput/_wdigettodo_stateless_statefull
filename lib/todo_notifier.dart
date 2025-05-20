import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/auth_provider.dart';
import 'todo_model.dart';
import 'todo_repository.dart';

final todoRepositoryProvider = Provider((ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  return TodoRepository(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
    user,
  );
});

final todoListProvider = StreamProvider<List<Todo>>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;

  if (user == null) {
    // Return an empty stream if no user is logged in
    return const Stream.empty();
  }

  final repo = ref.watch(todoRepositoryProvider);
  return repo.getTodos();
});

final todoControllerProvider = Provider((ref) {
  return ref.watch(todoRepositoryProvider);
});
