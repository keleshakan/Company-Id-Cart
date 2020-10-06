import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'datatabledemo.dart';
import 'services.dart';

class Register extends StatefulWidget {
  static int state = 0;
  Register() : super();

  final String title = 'Company Data Table';

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _schoolController = TextEditingController();
  final _districtController = TextEditingController();

  String _titleProgress;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<int> _counter;

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _counter = prefs.setInt("counter", counter).then((bool success) {
        return counter;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _controllerText();
    _incrementCounter();
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

    _schoolController.addListener(() {
      final text = _schoolController.text;
      _schoolController.value = _schoolController.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    _districtController.addListener(() {
      final text = _districtController.text;
      _districtController.value = _districtController.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  // Now lets add an Employee
  _addEmployee() {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty
        || _passwordController.text.isEmpty || _schoolController.text.isEmpty ||
        _districtController.text.isEmpty) {
      print('Empty Fields');
      return;
    }
    Services.addEmployee(_firstNameController.text, _lastNameController.text,
        _passwordController.text,_schoolController.text,_districtController.text)
        .then((result) {
      if ('success' == result) {
        // Refresh the List after adding each employee...
      }
    });
    _clearValues();
  }

  // Method to clear TextField values
  _clearValues() {
    _firstNameController.text = '';
    _lastNameController.text = '';
    _passwordController.text = '';
    _schoolController.text = '';
    _districtController.text = '';
  }
  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), // we show the progress in the title.
        centerTitle: true,// ..
      ),
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
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'First Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Last Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: _schoolController,
                decoration: InputDecoration.collapsed(
                  hintText: 'School Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: _districtController,
                decoration: InputDecoration.collapsed(
                  hintText: 'District',
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            IconButton(
              icon: Icon(Icons.person_add),
              iconSize: 24.0,
              color: Colors.blue[900],
              onPressed: () {
                _addEmployee();
                Navigator.pushReplacement(
                    context, new MaterialPageRoute(
                    builder: (context) => DataTableDemo()));

              },
            ),
            Text('Register'),
          ],
        ),
      ),
    );
  }
}
