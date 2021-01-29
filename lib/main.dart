import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpSection(),
      routes: {
        LandingPage.id: (context) => LandingPage(),
        LoginSection.id: (context) => LoginSection()
      },
    );
  }
}

class SignUpSection extends StatelessWidget {
  var email, password;

  @override
  Widget build(BuildContext context) {
    checkToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      if (token != null) {
        Navigator.pushNamed(context, LandingPage.id);
      }
    }

    checkToken();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                placeholder: "Email",
                keyboardType: TextInputType.emailAddress,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                placeholder: "Password",
                clearButtonMode: OverlayVisibilityMode.editing,
                obscureText: true,
                autocorrect: false,
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
            FlatButton.icon(
              onPressed: () async {
                await signup(email, password);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String token = prefs.getString('token');
                if (token != null) {
                  Navigator.pushNamed(context, LandingPage.id);
                }
              },
              icon: Icon(Icons.save),
              label: Text("Sign UP"),
            ),
            FlatButton(
                onPressed: () async {
                  Navigator.pushNamed(context, LoginSection.id);
                },
                child: Text("Login"))
          ],
        ),
      ),
    );
  }
}

class LoginSection extends StatelessWidget {
  static const String id = "LoginSection";
  var email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CupertinoTextField(
                  placeholder: "Email",
                  keyboardType: TextInputType.emailAddress,
                  clearButtonMode: OverlayVisibilityMode.editing,
                  autocorrect: false,
                  onChanged: (value) {
                    email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CupertinoTextField(
                  placeholder: "Password",
                  clearButtonMode: OverlayVisibilityMode.editing,
                  obscureText: true,
                  autocorrect: false,
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),
              FlatButton.icon(
                  onPressed: () async {
                    await login(email, password);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String token = prefs.getString('token');
                    if (token != null) {
                      Navigator.pushNamed(context, LandingPage.id);
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

signup(email, password) async {
  var url = "http://192.168.1.7:3000/signup";
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'email': email, 'password': password}),
  );
  print(response.body);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var parse = jsonDecode(response.body);
  print(parse);
  await prefs.setString('token', parse["token"]);
  String token = prefs.getString('token');
  print(token);

  // if (response.statusCode == 201) {
  // } else {
  //   throw Exception('Failed to create album.');
  // }
}

login(email, password) async {
  var url = "http://192.168.1.7:3000/login";
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'email': email, 'password': password}),
  );
  print(response.body);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var parse = jsonDecode(response.body);
  //print(parse["token"]);
  await prefs.setString('token', parse["token"]);
  String token = prefs.getString('token');
  print(token);

  // if (response.statusCode == 201) {
  // } else {
  //   throw Exception('Failed to create album.');
  // }
}

class LandingPage extends StatelessWidget {
  static const String id = "LandingPage";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Welcome to the landing page"),
          ),
          FlatButton.icon(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('token', null);
                Navigator.pushNamed(context, LoginSection.id);
              },
              icon: Icon(Icons.logout),
              label: Text("Logout"))
        ],
      ),
    );
  }
}
