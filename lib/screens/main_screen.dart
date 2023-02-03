import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_shopping_17/screens/auth_screen.dart';
import 'package:firebase_shopping_17/screens/shop_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ShopScreen();
          }else{
            return AuthScreen();
          }
        },
      ),
    );
  }
}
