import 'dart:convert';

import 'package:dutyhour/employee.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const DTRApp());
}

class DTRApp extends StatelessWidget {
  const DTRApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DTRLoginPage(),
    );
  }
}

class DTRLoginPage extends StatefulWidget {
  const DTRLoginPage({Key? key}) : super(key: key);

  @override
  _DTRLoginPageState createState() => _DTRLoginPageState();
}

class _DTRLoginPageState extends State<DTRLoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Icon(
              Icons.access_time,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Employee Daily Time Record Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _userController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                login();
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    String url = "http://192.168.0.105/flutter/api/login.php";

    final Map<String, dynamic> queryParams = {
      "username": _userController.text,
      "password": _passController.text,
    };

    try {
      http.Response response =
          await http.get(Uri.parse(url).replace(queryParameters: queryParams));

      if (response.statusCode == 200) {
        var user = jsonDecode(response.body);
        print(response.body);
        if (user.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeList(
                userid: user[0]['user_id'],
                userfullname: user[0]['full_name'],
              ),
            ),
          );
        } else {
          showMessageBox(
              context, "Login Failed", "Username or Password is Incorrect");
        }
      } else {
        showMessageBox(context, "Error", "Registration Failed !!!");
      }
    } catch (error) {
      print("Exception during HTTP request: $error");
      showMessageBox(
          context, "Error", "An error occurred during the HTTP request.");
    }
  }

  void showMessageBox(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        });
  }
}
