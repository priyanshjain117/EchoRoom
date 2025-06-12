import 'dart:async';
import 'package:flutter/material.dart';

import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _inSplashScreen=true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1),(){
      setState(() {
        _inSplashScreen=false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(214, 66, 197, 245),
        ),
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (_inSplashScreen || snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }else if (snapshot.hasData) {
            return const ChatScreen();
          }else{
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
