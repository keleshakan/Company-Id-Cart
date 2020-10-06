import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'employee.dart';
import 'services.dart';
import 'datatabledemo.dart';

class Database extends StatefulWidget {
  static String firsName;
  static String lastName;
  static String school;
  static String district;

  static int flag = 0;

  Database() : super();

  final String title = 'Database Information';
  static String id ;

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<Database> {
  List<Employee> _employees;
  GlobalKey<ScaffoldState> _scaffoldKey;
  // controller for the ID TextField we are going to create.
  TextEditingController _idController;
  // controller for the First Name TextField we are going to create.
  TextEditingController _firstNameController;
  // controller for the Last Name TextField we are going to create.
  TextEditingController _lastNameController;
  // controller for the Password TextField we are going to create.
  TextEditingController _passwordController;
  // controller for the School TextField we are going to create.
  TextEditingController _schoolController;
  // controller for the District TextField we are going to create.
  TextEditingController _districtController;

  Employee _selectedEmployee;
  bool _isUpdating;
  String _titleProgress;

  SharedPreferences loginData;
  SharedPreferences loginUser;

  @override
  void initState() {
    super.initState();
    _employees = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _passwordController = TextEditingController();
    _schoolController = TextEditingController();
    _districtController = TextEditingController();
    _idController = TextEditingController();
    _getEmployees();
  }

  void _setLogin() async {
    loginData = await SharedPreferences.getInstance();
    loginData.setBool('login', true);
  }

  void _setUser()async{
    loginUser = await SharedPreferences.getInstance();
    loginUser.setBool('user', true);
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _getEmployees() {
    _showProgress('Loading Employees...');
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${employees.length}");
    });
  }

  _updateEmployee(Employee employee) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Updating Employee...');
    Services.updateEmployee(
         _idController.text,_firstNameController.text, _lastNameController.text,
        _passwordController.text, _schoolController.text,_districtController.text)
        .then((result) {
      if ('success' == result) {
        _getEmployees(); // Refresh the list after update
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }else{
        print('nothing update!');
      }
    });
  }

  _deleteEmployee(String id) {
    _showProgress('Deleting Employee...');
    Services.deleteEmployee(id).then((result) {
      if ('success' == result) {
        _getEmployees(); // Refresh after delete...
      }
    });
  }

  // Method to clear TextField values
  _clearValues() {
    _firstNameController.text = '';
    _lastNameController.text = '';
    _passwordController.text = '';
    _schoolController.text = '';
    _districtController.text = '';
  }

  _showValues(Employee employee) {
    _firstNameController.text = employee.firstName;
    _lastNameController.text = employee.lastName;
    _passwordController.text = employee.password;
    _schoolController.text = employee.school;
    _districtController.text = employee.district;
    _idController.text = employee.id;
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
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('DELETE'),
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
                    onTap: () {
                      _showValues(employee);
                      // Set the Selected employee to Update
                      _selectedEmployee = employee;
                      // Set flag updating to true to indicate in Update Mode
                      setState(() {
                        _isUpdating = true;
                      });
                    },
                  ),
                  DataCell(
                    Text(
                      employee.lastName.toUpperCase(),
                    ),
                    onTap: () {
                      _showValues(employee);
                      // Set the Selected employee to Update
                      _selectedEmployee = employee;
                      setState(() {
                        _isUpdating = true;
                      });
                    },
                  ),
                  DataCell(IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Database.id = employee.id;
                      _showMyDialog();
                    },
                  )),
            ]),
          ).toList(),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Database.flag = 1;
                    _deleteEmployee(Database.id);
                  },
                ),
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/school2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100.0,),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'First Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Last Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _schoolController,
                decoration: InputDecoration.collapsed(
                  hintText: 'School',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _districtController,
                decoration: InputDecoration.collapsed(
                  hintText: 'District',
                ),
              ),
            ),
            // Add an update button and a Cancel Button
            // show these buttons only when updating an employee
            _isUpdating
                ? Row(
              children: <Widget>[
                OutlineButton(
                  child: Text('UPDATE'),
                  onPressed: () {
                    _updateEmployee(_selectedEmployee);
                  },
                ),
                OutlineButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    setState(() {
                      _isUpdating = false;
                    });
                    _clearValues();
                  },
                ),
              ],
            )
                : Container(),
            Expanded(
              child: _dataBody(),
            ),
            FlatButton.icon(
                onPressed: () {
                  _setUser();
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
    );
  }
}