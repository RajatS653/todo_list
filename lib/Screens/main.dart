import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/Auth/AuthScreen.dart';
import 'package:todo_list/Screens/Home.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
      ),
      home:  StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, UsersSnapshot){
        if(UsersSnapshot.hasData){
          return Home_screen();
        }
        else{
          return AuthScreen();
        }
      },),
    );
  }
}

