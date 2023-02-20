import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_shopping_17/screens/verify_code_screen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  final phoneNumberController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    phoneNumberController.text = '+79532602744';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child: TextFormField(
                  onChanged: (text) {
                    if (errorMessage != null) {
                      errorMessage = null;
                    }
                  },
                  maxLength: 12,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста введите номер';
                    } else if (value.length < 12) {
                      return 'Номер введен не полностью';
                    } else if (errorMessage != null) {
                      return errorMessage;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 3, color: Colors.blue),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      hintText: 'Введите номер телефона'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(150, 50)),
                  icon: loading
                      ? const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.login),
                  label: Text(loading ? 'Загрузка' : 'Войти'),
                  onPressed: loading
                      ? null
                      : () {
                          errorMessage = null;
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });

                            verifyPhoneNumber();
                          }
                        })
            ],
          ),
        ),
      ),
    );
  }

  void verifyPhoneNumber() {
    auth.verifyPhoneNumber(
        phoneNumber: phoneNumberController.text,
        timeout: const Duration(milliseconds: 60),
        verificationCompleted: (_) {
          setState(() {
            loading = false;
          });
        },
        verificationFailed: (e) {
          if (e.message!.contains(
              'The format of the phone number provided is incorrect')) {
            errorMessage = 'Неккоректный номер телефона';
          } else {
            errorMessage = e.message;
          }

          setState(() {
            loading = false;
          });
        },
        codeSent: (verificationId, token) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VerifyCodeScreen(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (e) {
          setState(() {
            loading = false;
          });
          // ignore: avoid_print
          print(e.toString());
        });
  }
}
