import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_test/ui/views/home/home_view.dart';
import 'package:new_test/ui/views/login/login_view.dart';

import 'core/data/locator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Test',
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}


class InitializerWidget extends StatefulWidget {
  const InitializerWidget({Key? key}) : super(key: key);

  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  FirebaseAuth? _auth;
  User? _user;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth!.currentUser!;
    loading = false;

  }
  @override
  Widget build(BuildContext context) {
    return loading ? const Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    ) : _user == null ? const LoginView() : const HomeView();
  }
}
