import 'dart:convert';
import 'package:dutyhour/employeelogs.dart';
import 'package:dutyhour/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class EmployeeList extends StatefulWidget {
  final String userid;
  final String userfullname;

  EmployeeList({
    required this.userid,
    required this.userfullname,
  });

  @override
  _EmployeeState createState() => _EmployeeState();
}

class _EmployeeState extends State<EmployeeList> {
  GlobalKey _qrKey = GlobalKey();
  QRViewController? _qrController;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  List<dynamic> employeeList = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    List myList = await getEmployee();

    print(myList);

    setState(() {
      employeeList = myList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Management'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Add Employee',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _fullnameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          labelText: 'Age',
                          prefixIcon: Icon(Icons.cake),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _genderController,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          save();
                        },
                        child: Text('Submit'),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
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
          // Refresh the data when the RefreshIndicator is triggered
          List myList = await getEmployee();
          setState(() {
            employeeList = myList;
          });
        },
        child: FutureBuilder(
          future: getEmployee(),
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
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            _showQRCodeScannerIn('Time In');
          },
          child: Text('Time In'),
        ),
        ElevatedButton(
          onPressed: () {
            _showQRCodeScannerOut('Time Out');
          },
          child: Text('Time Out'),
        ),
      ],
    );
  }

  Widget employeeListView() {
    return ListView.builder(
      itemCount: employeeList.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title:
                Text('Fullname: ${employeeList[index]['employee_fullname']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Age: ${employeeList[index]['employee_age']}'),
                Text('Gender: ${employeeList[index]['employee_gender']}'),
                Text('Address: ${employeeList[index]['employee_address']}'),
              ],
            ),
            trailing: InkWell(
              onTap: () {
                _showQRCodeDialog(employeeList[index]['employee_fullname'],
                    employeeList[index]['employee_id']);
              },
              child: Icon(Icons.qr_code),
            ),
          ),
        );
      },
    );
  }

  Future<List> getEmployee() async {
    String url = "http://192.168.0.105/flutter/api/getemployees.php";

    final Map<String, dynamic> queryParams = {
      "userid": widget.userid.toString(),
    };

    http.Response response =
        await http.get(Uri.parse(url).replace(queryParameters: queryParams));
    if (response.statusCode == 200) {
      var employee = jsonDecode(response.body);
      return employee;
    } else {
      return [];
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
      },
    );
  }

  void save() async {
    Uri uri = Uri.parse('http://192.168.0.105/flutter/api/addemployee.php');

    Map<String, dynamic> data = {
      'userid': widget.userid.toString(),
      'fullname': _fullnameController.text,
      'age': _ageController.text,
      'gender': _genderController.text,
      'address': _addressController.text,
    };

    print("Data being sent: $data");

    http.Response response = await http.post(uri, body: data);

    if (response.statusCode == 200) {
      if (response.body == '1') {
        showMessageBox(context, "Success!", "Employee successfully added");

        _refreshIndicatorKey.currentState?.show();
        Navigator.pop(context);
      } else {
        showMessageBox(context, "Error!", "Failed to add Employee");
      }
    } else {
      showMessageBox(
        context,
        "Error",
        "The server returns a ${response.statusCode} error.",
      );
    }
  }

  void _showQRCodeScannerIn(String logType) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('QR Code Scanner for $logType'),
                SizedBox(height: 20), // Increased gap for better readability
                SizedBox(
                  width: 300.0, // Increased width
                  height: 300.0, // Increased height
                  child: QRView(
                    key: _qrKey,
                    onQRViewCreated: (controller) {
                      _qrController = controller;
                      _qrController?.scannedDataStream.listen((scanData) {
                        // Handle the scanned data
                        print("Scanned Data: ${scanData.code}");
                        _handleScannedData(scanData);
                      });
                    },
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.red,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 300.0 - 40, // Adjust cutOutSize accordingly
                    ),
                  ),
                ),
                SizedBox(height: 20), // Increased gap for better readability
                Text(
                  'Scanned Data: ${_scannedData ?? "No data scanned"}',
                  style: TextStyle(
                    fontSize: 18, // Increased font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close Scanner'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _scannedData;
  bool _isLogProcessed = false;

  void _handleScannedData(Barcode scanData) async {
    if (_isLogProcessed) {
      return;
    }

    print("Scanned Employee ID: ${scanData.code}");

    int? scannedEmployeeID = int.tryParse(scanData.code ?? '');

    if (scannedEmployeeID != null) {
      String scannedEmployeeIDString = scannedEmployeeID.toString();

      print("Parsed Employee ID: $scannedEmployeeIDString");

      bool logResult = await _logTime(scannedEmployeeIDString, 'Time In');

      if (logResult) {
        print("Time In logged successfully!");

        _isLogProcessed = true;

        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Scanned Successfully'),
              content: Text('Time In logged successfully!'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _isLogProcessed = false;
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        print("Failed to log Time In.");
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to log Time In. Please try again.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _isLogProcessed = false;
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } else {
      print("Invalid Employee ID Format");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Scanned Data'),
            content:
                Text('The scanned data is not a valid employee ID format.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> _logTime(String employeeId, String logType) async {
    if (employeeId.isNotEmpty) {
      Uri uri = Uri.parse('http://192.168.0.105/flutter/api/timelog.php');

      Map<String, dynamic> data = {
        'employee_id': employeeId,
        'log_type': logType,
      };

      print("Data being sent: $data");

      try {
        http.Response response = await http.post(uri, body: data);

        print("HTTP Response: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
          return response.body == '1';
        } else {
          return false;
        }
      } catch (error) {
        print("Error: $error");
        return false;
      }
    } else {
      return false;
    }
  }

  void _showQRCodeScannerOut(String logType) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('QR Code Scanner for $logType'),
                SizedBox(height: 20), // Increased gap for better readability
                SizedBox(
                  width: 300.0, // Increased width
                  height: 300.0, // Increased height
                  child: QRView(
                    key: _qrKey,
                    onQRViewCreated: (controller) {
                      _qrController = controller;
                      _qrController?.scannedDataStream.listen((scanData) {
                        print("Scanned Data: ${scanData.code}");
                        _handleScannedDataOut(scanData);
                      });
                    },
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.red,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 300.0 - 40, // Adjust cutOutSize accordingly
                    ),
                  ),
                ),
                SizedBox(height: 20), // Increased gap for better readability
                Text(
                  'Scanned Data: ${_scannedDataOut ?? "No data scanned"}',
                  style: TextStyle(
                    fontSize: 18, // Increased font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close Scanner'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _scannedDataOut;
  bool _isLogProcessedOut = false;

  void _handleScannedDataOut(Barcode scanData) async {
    if (_isLogProcessedOut) {
      return;
    }

    print("Scanned Employee ID: ${scanData.code}");

    int? scannedEmployeeID = int.tryParse(scanData.code ?? '');

    if (scannedEmployeeID != null) {
      String scannedEmployeeIDString = scannedEmployeeID.toString();

      print("Parsed Employee ID: $scannedEmployeeIDString");

      bool logResult =
          await _logTimeToDatabase(scannedEmployeeIDString, 'Time Out');

      if (logResult) {
        print("Time Out logged successfully!");

        _isLogProcessedOut = true;

        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Scanned Successfully'),
              content: Text('Time Out logged successfully!'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _isLogProcessedOut = false;
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        print("Failed to log Time Out.");
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to log Time Out. Please try again.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _isLogProcessedOut = false;
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } else {
      print("Invalid Employee ID Format");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Scanned Data'),
            content:
                Text('The scanned data is not a valid employee ID format.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> _logTimeToDatabase(String employeeId, String logType) async {
    if (employeeId.isNotEmpty) {
      Uri uri = Uri.parse('http://192.168.0.105/flutter/api/timelog.php');

      Map<String, dynamic> data = {
        'employee_id': employeeId,
        'log_type': logType,
      };

      print("Data being sent: $data");

      try {
        http.Response response = await http.post(uri, body: data);

        print("HTTP Response: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
          return response.body == '1';
        } else {
          return false;
        }
      } catch (error) {
        print("Error: $error");
        return false;
      }
    } else {
      return false;
    }
  }

  void _showQRCodeDialog(String employeeName, employeeid) {
    showDialog(
      context: context,
      builder: (context) {
        String qrCodeData = '$employeeid';

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildQRImage(qrCodeData),
                SizedBox(height: 10),
                Text('Employee ID: $employeeid'),
                Text('Employee Name: $employeeName'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQRImage(String qrCodeData) {
    final containerKey = GlobalKey();
    return RepaintBoundary(
      key: containerKey,
      child: QrImageView(
        data: qrCodeData,
        version: QrVersions.auto,
        size: 150.0,
      ),
    );
  }

  @override
  void dispose() {
    _qrController?.dispose();
    super.dispose();
  }
}
