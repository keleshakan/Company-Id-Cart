import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xamp_connection/database.dart';
import 'database.dart';

class StudentID extends StatefulWidget {
  @override
  _StudentIDCardState createState() => _StudentIDCardState();
}

class _StudentIDCardState extends State<StudentID> {
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
    // TODO: implement initState
    super.initState();
    _incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/school3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.blue[100],
                radius: 40.0,
              ),
            ),
            Divider(
              height: 50.0,
              color: Colors.amberAccent,
            ),
            Text(
              'Student Name',
              style: TextStyle(
                color: Colors.indigo[800],
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10.0,),
            Text(
              '${Database.firsName} ${Database.lastName}',
              style: TextStyle(
                color: Colors.black54,
                letterSpacing: 2.0,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30.0,),
            Text(
              'School',
              style: TextStyle(
                color: Colors.indigo[800],
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10.0,),
            Text(
              '${Database.school}',
              style: TextStyle(
                color: Colors.black54,
                letterSpacing: 2.0,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50.0,),
            Text(
              'District',
              style: TextStyle(
                color: Colors.indigo[800],
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10.0,),
            Text(
              '${Database.district}',
              style: TextStyle(
                color: Colors.black54,
                letterSpacing: 2.0,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30.0,),
            Center(
              child: FlatButton.icon(
                  onPressed: (){
                    Navigator.pop(context,'/studentInfo');
                  },
                  icon: Icon(Icons.exit_to_app),
                  label: Text('Back')),
            ),
            FutureBuilder<int>(
                future: _counter,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      if (snapshot.hasError) {
                        return Text('');
                      } else {
                        return Text(
                          '',
                        );
                      }
                  }
                }),
          ],
        ),
      ),
    );
  }
}
