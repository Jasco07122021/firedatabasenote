import 'package:firedatabasenote/pages/home_page.dart';
import 'package:firedatabasenote/pages/login_pages/sign_in_page.dart';
import 'package:firedatabasenote/services/auth_service.dart';
import 'package:firedatabasenote/services/hive_db.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static String id = "/sign_up_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController controllerFName = TextEditingController();
  TextEditingController controllerLName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  bool _errorShow = false;

  void _doSingIn() {
    String firstName = controllerFName.text.trim().toString();
    String lastName = controllerLName.text.trim().toString();
    String email = controllerEmail.text.trim().toString();
    String password = controllerPassword.text.trim().toString();

    if (email.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
      setState(() {
        _errorShow = true;
      });
      return;
    }
      AuthService.signUpUser(name: "$firstName + $lastName",email: email, password: password).then((value) {
        if (value != null) {
          HiveDB.putUser(value);
          Navigator.pushReplacementNamed(context, HomePage.id);
        }
        else{
          Fluttertoast.showToast(
              msg: "Check your email or password",
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controllerLName.dispose();
    controllerFName.dispose();
    controllerPassword.dispose();
    controllerEmail.dispose();
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
              textField(text: "First Name", controller: controllerFName),
              const SizedBox(height: 10),
              textField(text: "Last Name", controller: controllerLName),
              const SizedBox(height: 10),
              textField(text: "Email", controller: controllerEmail),
              const SizedBox(height: 10),
              textField(text: "Password", controller: controllerPassword),
              const SizedBox(height: 10),
              MaterialButton(
                onPressed: _doSingIn,
                child: const Text("Sign Up"),
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
                      text: "Already have an account?",
                      children: [
                        TextSpan(
                          text: " Sign In",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushReplacementNamed(
                                context, SignInPage.id),
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

  TextField textField({text, required TextEditingController controller}) {
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
