import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'employee.dart';
import 'services.dart';
import 'database.dart';
import 'datatabledemo.dart';

class StudentInfo extends StatefulWidget {
  StudentInfo() : super();

  final String title = 'Database Information';
  static String id ;

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<StudentInfo> {
  List<Employee> _employees;
  GlobalKey<ScaffoldState> _scaffoldKey;

  SharedPreferences loginData;

  @override
  void initState() {
    super.initState();
    _employees = [];
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getEmployees();
  }

  void _setLogin() async {
    loginData = await SharedPreferences.getInstance();
    loginData.setBool('login', true);
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
    });
  }

  _getEmployees() {
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${employees.length}");
    });
  }

  // Let's create a DataTable and show the employee list in it.
  SingleChildScrollView _dataBody() {
    // Both Vertical and Horizontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('INFO'),
            ),
            DataColumn(
              label: Text('FIRST NAME'),
            ),
            DataColumn(
              label: Text('LAST NAME'),
            ),
          ],
          rows: _employees
              .map(
                (employee) => DataRow(cells: [
              DataCell(IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  Database.firsName = employee.firstName;
                  Database.lastName = employee.lastName;
                  Database.school = employee.school;
                  Database.district = employee.district;

                  Navigator.pushNamed(context, '/studentID');
                },
              )),
              DataCell(
                Text(
                  employee.firstName.toUpperCase(),
                ),
              ),
              DataCell(
                Text(
                  employee.lastName.toUpperCase(),
                ),
              ),
            ]),
          ).toList(),
        ),
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/school2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 250.0,),
              Expanded(
                child: _dataBody(),
              ),
              FlatButton.icon(
                  onPressed: (){
                    _setLogin();
                    Navigator.pushReplacement(
                        context, new MaterialPageRoute(
                        builder: (context) => DataTableDemo()));
                  },
                  icon: Icon(Icons.exit_to_app),
                  label: Text('Exit')),
            ],
          ),
        ),
      ),
    );
  }
}