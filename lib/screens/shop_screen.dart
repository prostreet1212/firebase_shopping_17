import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_shopping_17/model/product.dart';
import 'package:firebase_shopping_17/widgets/add_panel.dart';
import 'package:firebase_shopping_17/widgets/my_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import '../widgets/app_bar.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late CollectionReference<Product> products;
  late Product product;
  late Stream<List<Product>> productStream;
  late Stream<String> imageStream;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    products = FirebaseFirestore.instance
        .collection('products')
        .withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson(),
        );
    productStream = getAllProducts();
    imageStream = _loadBackgroundImage();
  }

  Stream<List<Product>> getProductIsBuy(bool isBuy) async* {
    yield* products
        .where('isBuy', isEqualTo: isBuy)
        .snapshots()
        .map((event) => event.docs.map((e) {
              product = e.data();
              product.id = e.id;
              return product;
            }).toList());
  }

  Stream<List<Product>> getAllProducts() async* {
    yield* products
        .orderBy('name')
        .snapshots()
        .map((event) => event.docs.map((e) {
              product = e.data();
              product.id = e.id;
              return product;
            }).toList());
  }

  void onGetAllProducts() {
    setState(() {
      productStream = getAllProducts();
    });
  }

  void onGetProductIsBuy(bool isBuy) {
    setState(() {
      productStream = getProductIsBuy(isBuy);
    });
  }

  Stream<String> _loadBackgroundImage() async* {
    final imageRef =
        FirebaseStorage.instance.ref().child('images/background.jpg');
    imageUrl =
        await imageRef.getDownloadURL().then((value) => value).catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
    yield imageUrl;
  }

  void addProduct(Product product) {
    products.add(Product(name: product.name, isBuy: product.isBuy));
  }

  void changeProduct(Product product) {
    Map<String, dynamic> dataUpdate = {
      'name': product.name,
      'isBuy': !product.isBuy
    };

    setState(() {
      products.doc(product.id).update(dataUpdate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 60),
        child: MyAppBar(
          onGetProductIsBuy: onGetProductIsBuy,
          onGetAllProducts: onGetAllProducts,
        ),
      ),
      body: StreamBuilder2(
        streams: StreamTuple2(productStream, imageStream),
        builder: (context, snapshots) {
          if (snapshots.snapshot1.connectionState == ConnectionState.waiting ||
              snapshots.snapshot1.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshots.snapshot1.connectionState ==
                  ConnectionState.active &&
              snapshots.snapshot1.connectionState == ConnectionState.active) {
            if (snapshots.snapshot1.hasError) {
              return const Text('errorka');
            } else if (snapshots.snapshot1.hasData &&
                snapshots.snapshot2.hasData) {
              List<Product> productList = snapshots.snapshot1.data!;
              String url = snapshots.snapshot2.data!;
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(url), fit: BoxFit.cover)),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: productList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MyCard(
                            product: productList[index],
                            onChangeProduct: changeProduct,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 10,
                            color: Colors.blue,
                          );
                        },
                      ),
                    ),
                    AddPanel(onAddProduct: addProduct),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          } else {
            return const Text('error');
          }
        },
      ),
    );
  }
}
