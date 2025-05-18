import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/auth_provider.dart';
import 'package:todo/login_screen.dart';
import 'package:todo/to_do.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: authState.when(
        data: (user) {
          if (user != null) {
            return  TodoApp();
          } else {
            return  LoginScreen();
          }
        },
        loading: () =>  Scaffold(body: Center(child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.black,
        size: 200,
      ),)),
        error: (e, _) => Scaffold(body: Center(child: Text('Error: \$e'))),
      ),
    );
  }
}
