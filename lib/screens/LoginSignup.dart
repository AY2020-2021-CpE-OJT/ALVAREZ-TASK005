import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'contacts.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  var myemail;
  var mypassword;

  @override
  Widget build(BuildContext context) {
    checkToken() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString("token");
      if (token != null) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Contacts()), (_) => false);
      }
    }

    checkToken();

    return Scaffold(
      // navigationBar: CupertinoNavigationBar(
      //   automaticallyImplyLeading: false,
      // ),
      backgroundColor: Colors.purpleAccent,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.yellowAccent[400],
                    ),
                    child: Column(
                      children: <Widget>[
                        Text('Phone Book',
                            style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple)),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 400,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              primary: Colors.purple,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, SignupSection.id);
                            },
                            child: Text('Sign up'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              primary: Colors.purple,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, LoginSection.id);
                            },
                            child: Text('Log In'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // child: Column(
          //   children: [

          //   ],
          // ),
        ),
      ),
    );
  }
}

class LoginSection extends StatelessWidget {
  static const String id = "LoginSection";
  var myemail;
  var mypassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Log In Section"),
      ),
      body: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CupertinoTextField(
                  placeholder: "Email",
                  onChanged: (value) {
                    myemail = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CupertinoTextField(
                  placeholder: "Password",
                  obscureText: true,
                  onChanged: (value) {
                    mypassword = value;
                  },
                ),
              ),
              FlatButton.icon(
                  onPressed: () async {
                    await login(myemail, mypassword);
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    String token = preferences.getString("token");
                    if (token != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Contacts()),
                          (_) => false);
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}

class SignupSection extends StatelessWidget {
  static const String id = "SignupSection";
  var newEmail;
  var newPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sign Up for new account"),
      ),
      body: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            automaticallyImplyLeading: false,
          ),
          child: SafeArea(
              child: ListView(padding: const EdgeInsets.all(18), children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CupertinoTextField(
                    placeholder: "Enter new Email",
                    onChanged: (value) {
                      newEmail = value;
                    })),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CupertinoTextField(
                    placeholder: "Enter new Password",
                    obscureText: true,
                    onChanged: (value) {
                      newPassword = value;
                    })),
            FlatButton.icon(
                onPressed: () async {
                  await signup(newEmail, newPassword);
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return LoginSection();
                  }));
                },
                icon: Icon(Icons.save),
                label: Text("Proceed to Login"))
          ]))),
    );
  }
}

login(email, password) async {
  var url = "https://kisi-api.herokuapp.com/Contacts2/login"; // iOS
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  print(response.body);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var parse = jsonDecode(response.body);

  await preferences.setString('token', parse["token"]);
}

signup(email, password) async {
  var url = "https://kisi-api.herokuapp.com/Contacts2/signup";
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{'email': email, 'password': password}),
  );
  print(response.body);
}
