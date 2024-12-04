class Employee {
  final String? id;

  String name, email;

  Employee({this.id, required this.name, required this.email});

  Map<String, dynamic> toJson()=>{
    'id': id,
    'name': name,
    'email': email,
  };

  static Employee fromJson(Map<String, dynamic> json) => Employee(
      id: json['id'],
      name: json['name'], 
      email: json['email'],
    );
}