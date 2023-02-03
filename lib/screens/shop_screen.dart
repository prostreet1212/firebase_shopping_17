

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_shopping_17/model/product.dart';
import 'package:firebase_shopping_17/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late CollectionReference<Product> products;

  @override
  void initState() {
    super.initState();
    products = FirebaseFirestore.instance
        .collection('products')
        .withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase shop'),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                child: Icon(Icons.exit_to_app),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                      (route) => false);
                  showToast('Вы вышли из личного кабинета');
                },
              ))
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: products
            .snapshots()
            .map((event) => event.docs.map((e) => e.data()).toList()),
        builder: (context, snapshot) {
           switch (snapshot.connectionState){
             case ConnectionState.waiting:
               return Center(child: CircularProgressIndicator(),);
             case ConnectionState.active:
               if(snapshot.hasError){
                 return Center(child: Text(snapshot.error.toString()),);
               }else{
                 List<Product> productList=snapshot.data!;
                 return ListView(
                   children: productList.map((product) => ListTile(
                     leading: Text(product.name),
                     trailing: Icon(product.isBuy?Icons.shopping_basket:Icons.shopping_basket_outlined),

                   ),).toList(),
                 );
               }
               break;
             default:return Container();
           }
          },
      ),
    );
  }
}
