import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authControllerProvider);
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(onPressed: auth.signInWithGoogle, 
        label: Text("Sign in with Google"),
        icon: Icon(Icons.login),
        ),
      ),
    );
  }
}