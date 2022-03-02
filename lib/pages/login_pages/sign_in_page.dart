import 'package:firedatabasenote/pages/login_pages/sign_up_page.dart';
import 'package:firedatabasenote/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import '../../services/hive_db.dart';
import '../home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static String id = "/sign_in_page";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  bool _errorShow = false;

  _doSignUp() {
    String email = controllerEmail.text.toString().trim();
    String password = controllerPassword.text.toString().trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorShow = true;
      });
      return;
    }
    AuthService.signInUser(password: password,email: email).then((value) {
      Logger().d(value);
      if(value != null){
        HiveDB.putUser(value);
        Navigator.pushReplacementNamed(context, HomePage.id);
      }
      else{
        Fluttertoast.showToast(
            msg: "Check your email and password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }

  _errorText(String text) {
    if (text.trim().toString().isEmpty) {
      return "Can't be empty";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textField(text: "Email", controller: controllerEmail),
              const SizedBox(height: 10),
              textField(text: "Password", controller: controllerPassword),
              const SizedBox(height: 10),
              MaterialButton(
                onPressed: _doSignUp,
                child: const Text("Sign In"),
                color: Colors.blue,
                minWidth: double.infinity,
                height: 50,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account?",
                      children: [
                        TextSpan(
                          text: " Sign Up",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacementNamed(context, SignUpPage.id);
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField textField({text, controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        errorText: _errorShow ? _errorText(controller.text) : null,
      ),
      onChanged: (_) => setState(() {}),
    );
  }
}
