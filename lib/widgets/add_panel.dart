import 'package:firebase_shopping_17/model/product.dart';
import 'package:flutter/material.dart';

class AddPanel extends StatefulWidget {
  const AddPanel({Key? key, required this.onAddProduct}) : super(key: key);
  final Function(Product product) onAddProduct;

  @override
  State<AddPanel> createState() => _AddPanelState();
}

class _AddPanelState extends State<AddPanel> {
  List<String> items = ['Куплено', 'Не куплено'];
  String selectedItem = 'Куплено';
  TextEditingController productNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                  controller: productNameController,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.blue), //<-- SEE HERE
                    ),
                    hintText: 'Введите товар',
                  )),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          DropdownButton<String>(
            value: selectedItem,
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (String? oldValue) {
              setState(() {
                selectedItem = oldValue!;
              });
            },
          ),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
            child: const Text('Добавить'),
            onPressed: () {
              Product product = Product(
                  name: productNameController.text,
                  isBuy: selectedItem == 'Куплено' ? true : false);
              widget.onAddProduct(product);
              productNameController.text = '';
            },
          )
        ],
      ),
    );
  }
}
