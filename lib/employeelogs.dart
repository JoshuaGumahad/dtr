import 'dart:convert';

import 'package:dutyhour/employee.dart';
import 'package:dutyhour/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Employeelogs extends StatefulWidget {
  final String userid;
  final String userfullname;

  Employeelogs({
    required this.userid,
    required this.userfullname,
  });

  @override
  _EmployeelogsState createState() => _EmployeelogsState();
}

class _EmployeelogsState extends State<Employeelogs> {
  List<dynamic> employeelogsList = [];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    List myList = await getAllEmployeeLogs();

    print(myList);

    setState(() {
      employeelogsList = myList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Logs'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Admin: ${widget.userfullname}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Employee Management'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EmployeeList(
                            userid: widget.userid,
                            userfullname: widget.userfullname,
                          )),
                );
              },
            ),
            ListTile(
              title: Text('Employee Logs'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Employeelogs(
                            userid: widget.userid,
                            userfullname: widget.userfullname,
                          )),
                );
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DTRLoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          List myList = await getAllEmployeeLogs();
          setState(() {
            employeelogsList = myList;
          });
        },
        child: FutureBuilder(
          future: getAllEmployeeLogs(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text("Loading....."),
                    ],
                  ),
                );
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }
                return employeeListView();
              default:
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
            }
          },
        ),
      ),
    );
  }

  Widget employeeListView() {
    return ListView.builder(
      itemCount: employeelogsList.length,
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
          title: Text(
            'Employee Fullname: ${employeelogsList[index]['employee_fullname']}',
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log Type: ${employeelogsList[index]['log_type']}'),
              Text('Log Time: ${employeelogsList[index]['log_time']}'),
            ],
          ),
        ));
      },
    );
  }

  Future<List> getAllEmployeeLogs() async {
    String url = "http://192.168.0.105/flutter/api/getlogs.php";

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var employeeLogs = jsonDecode(response.body);
      return employeeLogs;
    } else {
      return [];
    }
  }
}
