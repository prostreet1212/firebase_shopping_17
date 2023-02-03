import 'package:firebase_shopping_17/screens/auth_screen.dart';
import 'package:firebase_shopping_17/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oktoast/oktoast.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
        textStyle: const TextStyle(fontSize: 19.0, color: Colors.white),
        backgroundColor: const Color.fromARGB(113, 145, 148, 139),
        position: ToastPosition.bottom,
        textPadding: const EdgeInsets.all(8),
        duration: const Duration(seconds: 3),
        child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    ));
  }
}
