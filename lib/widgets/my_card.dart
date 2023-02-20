import 'package:firebase_shopping_17/model/product.dart';
import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  const MyCard({Key? key, required this.product, required this.onChangeProduct})
      : super(key: key);
  final Product product;
  final Function(Product product) onChangeProduct;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(product.name.toString()),
      trailing: GestureDetector(
        child: Icon(product.isBuy
            ? Icons.shopping_basket
            : Icons.shopping_basket_outlined),
        onTap: () {
          onChangeProduct(product);
        },
      ),
    );
  }
}
