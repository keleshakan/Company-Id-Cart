import 'dart:convert';
import 'package:http/http.dart' as http; // add the http plugin in pubspec.yaml file.
import 'employee.dart';

class Services {
  static int data = 1;

  static const ROOT = 'http://10.0.2.2/EmployeesDB/employee_actions.php';//testdb panel
  static const ROOT2 = 'http://10.0.2.2/EmployeesDB/employee_action2.php';//admin panel
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_EMP_ACTION = 'ADD_EMP';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const _DELETE_EMP_ACTION = 'DELETE_EMP';
  static const _SEARCH_EMP_ACTION = 'SEARCH_DATA';

  // Method to create the table Employees.
  static Future<String> createTable() async {
    try {
      // add the parameters to pass to the request.
      var map = Map<String, dynamic>();
      var response;
      map['action'] = _CREATE_TABLE_ACTION;

      if(Services.data == 1){
        response = await http.post(ROOT, body: map);
      }else{
        response = await http.post(ROOT2, body: map);
      }

      print('Create Table Response: ${response.body}');

      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<List<Employee>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      var response;
      map['action'] = _GET_ALL_ACTION;

      if(Services.data == 1){
        response = await http.post(ROOT, body: map);
      }else{
        response = await http.post(ROOT2, body: map);
      }

      if (200 == response.statusCode) {
        List<Employee> list = parseResponse(response.body);
        return list;
      } else {
        return List<Employee>();
      }
    } catch (e) {
      print(e.toString());
      return List<Employee>(); // return an empty list on exception/error
    }
  }

  static Future<List<Employee>> getData(String firstName,String lastName,String password) async {
    try {
      var map = Map<String, dynamic>();
      var response;

      map['action'] = _SEARCH_EMP_ACTION;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      map['password'] = password;

      if(Services.data == 1){
        response = await http.post(ROOT, body: map);
      }else{
        response = await http.post(ROOT2, body: map);
      }

      if (200 == response.statusCode) {
        List<Employee> list = parseResponse(response.body);

        return list;
      } else {
        return List<Employee>();
      }
    } catch (e) {
      print(e.toString());
      return List<Employee>(); // return an empty list on exception/error
    }
  }


  static List<Employee> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }

  // Method to add employee to the database...
  static Future<String> addEmployee(String firstName, String lastName,
      String password,String school,String district) async {
    try {
      var map = Map<String, dynamic>();
      var response;

      map['action'] = _ADD_EMP_ACTION;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      map['password'] = password;
      map['school'] = school;
      map['district'] = district;

      if(Services.data == 1){
        response = await http.post(ROOT, body: map);
      }else{
        response = await http.post(ROOT2, body: map);
      }

      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to update an Employee in Database...
  static Future<String> updateEmployee(
       String id,String firstName, String lastName ,
      String password , String school,String district) async {
    try {
      var map = Map<String, dynamic>();

      map['action'] = _UPDATE_EMP_ACTION;
      map['id'] = id;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      map['password'] = password;
      map['school'] = school;
      map['district'] = district;

      final response = await http.post(ROOT,body: map);

      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an Employee from Database...
  static Future<String> deleteEmployee(String empId) async {
    try {
      var map = Map<String, dynamic>();
      var response;

      map['action'] = _DELETE_EMP_ACTION;
      map['id'] = empId;

      if(Services.data == 1){
        response = await http.post(ROOT, body: map);
      }else{
        response = await http.post(ROOT2, body: map);
      }

      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }
}
