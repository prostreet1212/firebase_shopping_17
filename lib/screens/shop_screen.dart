import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:firebase_shopping_17/model/product.dart';
import 'package:firebase_shopping_17/screens/auth_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:oktoast/oktoast.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late CollectionReference<Product> products;
  String selectedItem = 'Куплено';
  List<String> items = ['Куплено', 'Не куплено'];
  final productController = TextEditingController();
  late Product product;
  late Stream<List<Product>> productStream;
  late Stream<String> imageStream;
  late String imageUrl;
    static const  List<String> filterProductList =   <String>[
    "Все товары",
    "Куплено",
    "Не куплено",
  ];

  ValueNotifier<String> selectedFilterItem =  ValueNotifier<String>(filterProductList[0]);

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
    imageStream=_loadBackgroundImage();
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

  Stream<String> _loadBackgroundImage() async* {
    final imageRef =
        FirebaseStorage.instance.ref().child('images/background.jpg');
    imageUrl = await imageRef
        .getDownloadURL()
        .then((value) => value)
        .catchError(() {});
    print(imageUrl);
    yield imageUrl;
  }

  void addProduct() {
    products.add(Product(
        name: productController.text,
        isBuy: selectedItem == 'Куплено' ? true : false));
    productController.text = '';
  }

  void changeProduct(Product product) {
    Map<String, dynamic> dataUpdate = {
      'name': product.name,
      'isBuy': !product.isBuy
    };
    products.doc(product.id).update(dataUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Firebase shop'),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.filter_alt),
              //onSelected: _select,
              padding: EdgeInsets.zero,
              // initialValue: choices[_selection],
              itemBuilder: (context) {
                return List<PopupMenuEntry<String>>.generate(
                    filterProductList.length, (index) {
                  return PopupMenuItem(
                    child: AnimatedBuilder(
                      animation: selectedFilterItem,
                      builder: (context,child){
                        return RadioListTile(
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: filterProductList[index],
                            groupValue: selectedFilterItem.value,
                            title: Text(filterProductList[index]),
                            onChanged: (String? value) {
                              selectedFilterItem.value=value!;
                             if(selectedFilterItem.value==filterProductList[1]){
                               Navigator.pop(context);
                               setState(() {
                                 productStream=getProductIsBuy(true);
                               });
                             }else if(selectedFilterItem.value==filterProductList[2]){
                               Navigator.pop(context);
                               setState(() {
                                 productStream=getProductIsBuy(false);
                               });
                             }else{
                               Navigator.pop(context);
                               setState(() {
                                 productStream=getAllProducts();
                               });
                             }
                            });
                      },

                    ),
                  );
                });
                /* return filterProductList.map((String choice) {
                  return  PopupMenuItem(
                      child: RadioListTile<String>(
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: selectedFilterItem,
                        groupValue: selectedFilterItem,
                        title: Text(choice),
                        onChanged: (String? value) {
                          setState(() {
                            selectedFilterItem=value!;
                            print(selectedFilterItem);
                          });
                        },
                      ),
                  );
                }
                ).toList();*/
              },
            ),
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
              ),
            ),
          ],
        ),
        body: StreamBuilder2(
          streams:StreamTuple2(productStream, imageStream),
          builder: (context,snapshots){
            if(snapshots.snapshot1.connectionState==ConnectionState.waiting||snapshots.snapshot1.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }else if(snapshots.snapshot1.connectionState==ConnectionState.active&&snapshots.snapshot1.connectionState==ConnectionState.active){
              if(snapshots.snapshot1.hasError){
                return Text('errorka');
              }else if (snapshots.snapshot1.hasData&&snapshots.snapshot2.hasData){
                List<Product> productList = snapshots.snapshot1.data!;
                String url=snapshots.snapshot2.data!;
                return Container(
                  decoration:  BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child:     ListView.separated(
                          itemCount: productList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                leading:
                                Text(productList[index].name.toString()),
                                trailing: GestureDetector(
                                  child: Icon(productList[index].isBuy
                                      ? Icons.shopping_basket
                                      : Icons.shopping_basket_outlined),
                                  onTap: () {
                                    changeProduct(productList[index]);
                                  },
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              height: 10,
                              color: Colors.blue,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: TextField(
                                    controller: productController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.blue), //<-- SEE HERE
                                      ),
                                      hintText: 'Введите товар',
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            DropdownButton<String>(
                              value: selectedItem,
                              items: items
                                  .map((item) =>
                                  DropdownMenuItem(value: item, child: Text(item)))
                                  .toList(),
                              onChanged: (String? oldValue) {
                                setState(() {
                                  selectedItem = oldValue!;
                                });
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              child: Text('Добавить'),
                              onPressed: () {
                                addProduct();
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }else{
                return SizedBox();
              }
            }
            else{
              return Text('error');
            }
          },
        )
    );
  }
}
