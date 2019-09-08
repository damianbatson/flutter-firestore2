import 'package:flutter/material.dart';
import 'package:prototypedeus/auth.dart';
import 'package:prototypedeus/auth_provider.dart';
import 'package:prototypedeus/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
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
