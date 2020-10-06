class Employee{
  String id;
  String firstName;
  String lastName;
  String password;
  String school;
  String district;

  Employee({this.id,this.firstName,this.lastName, this.password ,this.school,this.district});

  factory Employee.fromJson(Map<String,dynamic> json){
    return Employee(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      password: json['password'] as String,
      school: json['school'] as String,
      district: json['district'] as String,
    );
  }
}