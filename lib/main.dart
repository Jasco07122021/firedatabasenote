import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firedatabasenote/pages/detail_page.dart';
import 'package:firedatabasenote/pages/home_page.dart';
import 'package:firedatabasenote/pages/login_pages/sign_in_page.dart';
import 'package:firedatabasenote/pages/login_pages/sign_up_page.dart';
import 'package:firedatabasenote/services/hive_db.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox(HiveDB.nameDB);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final RouteObserver<PageRoute> routeObserver =
  RouteObserver<PageRoute>();


  _checkLogin() {
    final FirebaseAuth  _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
     if (user == null) {
       HiveDB.removeUser();
      return const SignInPage();
    }
     HiveDB.putUser(user);
     return const HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: _checkLogin(),
      routes: {
        SignUpPage.id: (context) => const SignUpPage(),
        SignInPage.id: (context) => const SignInPage(),
        HomePage.id: (context) => const HomePage(),
        DetailPage.id: (context) => const DetailPage(),
      },
    );
  }
}
