import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import '../screens/auth_screen.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar(
      {Key? key,
      required this.onGetProductIsBuy,
      required this.onGetAllProducts})
      : super(key: key);

  final Function(bool isBuy) onGetProductIsBuy;
  final Function() onGetAllProducts;

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  static const List<String> filterProductList = <String>[
    "Все товары",
    "Куплено",
    "Не куплено",
  ];
  ValueNotifier<String> selectedFilterItem =
      ValueNotifier<String>(filterProductList[0]);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Firebase shop'),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.filter_alt),
          padding: EdgeInsets.zero,
          itemBuilder: (context) {
            return List<PopupMenuEntry<String>>.generate(
                filterProductList.length, (index) {
              return PopupMenuItem(
                child: AnimatedBuilder(
                  animation: selectedFilterItem,
                  builder: (context, child) {
                    return RadioListTile(
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: filterProductList[index],
                        groupValue: selectedFilterItem.value,
                        title: Text(filterProductList[index]),
                        onChanged: (String? value) {
                          selectedFilterItem.value = value!;
                          if (selectedFilterItem.value ==
                              filterProductList[1]) {
                            Navigator.pop(context);
                            widget.onGetProductIsBuy(true);
                          } else if (selectedFilterItem.value ==
                              filterProductList[2]) {
                            Navigator.pop(context);
                            widget.onGetProductIsBuy(false);
                          } else {
                            Navigator.pop(context);
                            widget.onGetAllProducts();
                          }
                        });
                  },
                ),
              );
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            child: const Icon(Icons.exit_to_app),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (route) => false);
              showToast('Вы вышли из личного кабинета');
            },
          ),
        ),
      ],
    );
  }
}
