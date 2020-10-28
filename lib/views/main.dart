import 'package:flutter/material.dart';
import 'package:prototypedeus/views/auth.dart';
import 'package:prototypedeus/views/provider.dart';
import 'package:prototypedeus/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        title: 'Flutter login demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RootPage(),
      ),
    );
  }
}
