// @dart=2.9
import 'package:flutter/material.dart';
import 'package:updated_app/screens/LoginSignup.dart';
import 'screens/contacts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contacts App',
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          accentColor: Colors.redAccent,
        ),
        home: Authenticate(),
        routes: <String, WidgetBuilder>{
          Contacts.id: (context) => Contacts(),
          LoginSection.id: (context) => LoginSection(),
          SignupSection.id: (context) => SignupSection(),
          '/contacts': (BuildContext context) => new Contacts(),
          'Log in': (BuildContext context) => new LoginSection(),
          'Sign up': (BuildContext context) => new SignupSection(),
        });
  }
}
