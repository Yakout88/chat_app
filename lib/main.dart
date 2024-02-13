import 'package:chat_app/firebase_options.dart';
// import 'package:chat_app/views/chat_screen.dart';
import 'package:chat_app/views/sign_view.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      
      debugShowCheckedModeBanner: false,
      home:SignView()
      // FirebaseAuth.instance.currentUser==null? SignView(): ChatScreen(email: ""),
    
    );
  }
}
