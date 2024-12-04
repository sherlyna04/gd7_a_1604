import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gd7_a_1604/entity/employee.dart';

class InputPage extends StatefulWidget {
  const InputPage(
    {super.key,
    required this.title,
    required this.id,
    required this.name,
    required this.email});

  final String? title, name, email, id;

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(widget.id!=null){
      controllerName.text = widget.name!;
      controllerEmail.text = widget.email!;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("INPUT EMPLOYEE"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: controllerName,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Name',
            ),
          ),
          SizedBox(height: 24),
          TextField(
            controller: controllerEmail,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Email',
            ),
          ),
          SizedBox(height: 48),
          ElevatedButton(
            child: Text('Save'),
            onPressed: () async {
              if(widget.id == null){
                createEmployee(
                  name: controllerName.text, email: controllerEmail.text);
              }else{
                final docEmployee = FirebaseFirestore.instance
                    .collection('employee')
                    .doc(widget.id);
                docEmployee.update({
                  'name': controllerName.text,
                  'email': controllerEmail.text,
                });
              }
              Navigator.pop(context);
            },
          )
        ],
      ));
  }

  Future createEmployee({required String name, required String email}) async {
    final docEmployee = FirebaseFirestore.instance.collection('employee').doc();

    final employee = Employee(id: docEmployee.id, name: name, email: email);
    final json = employee.toJson();

    await docEmployee.set(json);
  }
}