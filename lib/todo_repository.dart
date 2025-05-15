import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'todo_model.dart';

class TodoRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  TodoRepository(this.firestore, this.auth);

  CollectionReference get _todoCollection => firestore
      .collection('user')
      .doc(auth.currentUser!.uid)
      .collection('todos');

  Stream<List<Todo>> getTodos() {
    return _todoCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => Todo.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();
    });
  }

  Future<void> addTodo(String text) {
    return _todoCollection.add({'text': text, 'isDone': false});
  }

  Future<void> toggleTodo(Todo todo) {
    return _todoCollection.doc(todo.id).update({'isDone': !todo.isDone});
  }

  Future<void> deleteTodo(String id) {
    return _todoCollection.doc(id).delete();
  }
}
