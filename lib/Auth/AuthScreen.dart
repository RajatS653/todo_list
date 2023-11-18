import 'package:flutter/material.dart';
import 'package:todo_list/Auth/AuthForm.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Authentication", style: TextStyle(color: Colors.white),),
      ),
      body: AuthForm(),
    );
  }
}
