import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_shopping_17/screens/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;

  const VerifyCodeScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final verifyCodeController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //verifyCodeController.text='123456';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Введите 6-значный код из смс'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: verifyCodeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 3, color: Colors.blue), //<-- SEE HERE
                  borderRadius: BorderRadius.circular(50.0),
                ),
                hintText: '6-значный код',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(fixedSize: const Size(150, 50)),
              icon: loading
                  ? const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox(),
              label: Text(loading ? 'Загрузка' : 'Отправить'),
              onPressed: loading
                  ? null
                  : () async {
                      setState(() {
                        loading = true;
                      });
                      final credential = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: verifyCodeController.text.toString(),
                      );
                      //try {
                      await auth.signInWithCredential(credential)
                          .then((value) {
                        setState(() {
                          loading = false;
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShopScreen()),
                                (route) => false);
                        showToast('Вход успешно выполнен');
                      }).catchError((e) {
                        setState(() {
                          loading = false;
                        });
                        e.toString().contains(
                                'The sms verification code used to create the phone auth credential is invalid')
                            ? showToast('Неверный код')
                            : showToast(e.toString());
                      });
                    },
            )
          ],
        ),
      ),
    );
  }
}
