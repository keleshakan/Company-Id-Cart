import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xamp_connection/database.dart';
import 'package:xamp_connection/register.dart';
import 'employee.dart';
import 'services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'studentInfo.dart';

class DataTableDemo extends StatefulWidget {
  static int flag = 0;

  DataTableDemo() : super();

  final String title = 'Company Data Table';

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  static Color bgColor = Colors.indigo[50];
  List<Employee> _employees;
  GlobalKey<ScaffoldState> _scaffoldKey;
  // controller for the First Name TextField we are going to create.
  //TextEditingController _firstNameController;
  // controller for the Last Name TextField we are going to create.
  //TextEditingController _lastNameController;
  // controller for the Password TextField we are going to create.
  //TextEditingController _passwordController;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();

  SharedPreferences loginData;
  SharedPreferences loginUser;

  bool newUser;
  bool newPage;

  @override
  void initState() {
    super.initState();
    _employees = [];
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getEmployees();
    _controllerText();
    _checkAlreadyLogin();
  }

  void _checkAlreadyLogin() async {
    loginData = await SharedPreferences.getInstance();
    loginUser = await SharedPreferences.getInstance();

    newUser = (loginData.getBool('login') ?? true);
    newPage = (loginUser.getBool('user') ?? true);

    if (newUser == false && newPage == false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => Database()));
    }else if(newUser == false && newPage == true){
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => StudentInfo()));
    }
  }

  _controllerText(){
    _firstNameController.addListener(() {
      final text = _firstNameController.text;
      _firstNameController.value = _firstNameController.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });

    _lastNameController.addListener(() {
      final text = _lastNameController.text;
      _lastNameController.value = _lastNameController.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });

    _passwordController.addListener(() {
      final text = _passwordController.text;
      _passwordController.value = _passwordController.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
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
                Text('This person does not exist.'),
                Text('Please Register!'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _getEmployees() {
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees;
      });
      print("Length ${_employees.length}");
    });
  }

  _getInfo(){
    Services.getData(_firstNameController.text, _lastNameController.text,_passwordController.text).then((result) {
      if (result.isNotEmpty){
        Services.data = 1;
        loginData.setBool('login', false);

        if(DataTableDemo.flag == 1){
          Navigator.pushReplacement(
              context, new MaterialPageRoute(builder: (context) => Database()));
        }else if(DataTableDemo.flag == 0){
          Navigator.pushReplacement(
              context, new MaterialPageRoute(builder: (context) => StudentInfo()));
        }else{
          //do nothing!
        }

        print('found the object');
      }else{
        _showMyDialog();
        print('not found the object');
      }
    });
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton.icon(
                    onPressed: (){
                      loginUser.setBool('user', false);
                      DataTableDemo.flag = 1;
                      bgColor = Colors.indigo;
                      //Navigator.pop(context);
                    },
                    icon: Icon(Icons.person),
                    label: Text('Admin'),
                    disabledColor: Colors.indigo,
                  ),
                  FlatButton.icon(
                    onPressed: (){
                      loginUser.setBool('user', true);
                      DataTableDemo.flag = 0;
                    },
                    icon: Icon(Icons.person),
                    label: Text('Student'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
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
            SizedBox(height: 10.0,),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              iconSize: 24.0,
              color: Colors.blue[800],
              onPressed: () {
                _getInfo();
                },
            ),
            Text('Enter'),
            SizedBox(height: 30.0,),
            FlatButton.icon(
                onPressed: (){
                  //Navigator.pop(context);
                },
                icon: Icon(Icons.exit_to_app),
                label: Text('Exit')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, new MaterialPageRoute(builder: (context) => Register()));
        },
        child: Icon(Icons.person_add),
      ),
    );
  }
}