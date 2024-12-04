import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gd7_a_1604/entity/employee.dart';
import 'package:gd7_a_1604/inputPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(
        title: 'Firebase',
      )
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override 
  void initState(){
    //refresh();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EMPLOYEE"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InputPage(
                    title: 'INPUT EMPLOYEE',
                    id: null,
                    name: null,
                    email: null)),
                );
            }),
          IconButton(icon: Icon(Icons.clear), onPressed: () async {})
        ],
      ),
      body: StreamBuilder(
        stream: getEmployee(), 
        builder: (context, snapshot) {
          if(snapshot.hasError){
            Center(child: Text('Something went wrong'));
          }
          if(snapshot.hasData) {
            final employees = snapshot.data!;
            return ListView(
              children: employees.map(buildEmployee).toList(),
            );
          }else{
            return Center(child: Text('NO DATA'));
          }
        }));
  }

  Widget buildEmployee(Employee employee) => Slidable(
    endActionPane: ActionPane(
      motion: const DrawerMotion(),
      children: [
        SlidableAction(
          onPressed: (context) async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputPage(
                  title: 'INPUT EMPLOYEE',
                  id: employee.id,
                  name: employee.name,
                  email: employee.email,
                ),
              ),
            );
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: Icons.update,
          label: 'Update',
        ),
        SlidableAction(
          onPressed: (context) async {
            final docEmployee = FirebaseFirestore.instance
                .collection('employee')
                .doc(employee.id);
            await docEmployee.delete();
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    ),
    child: ListTile(
      title: Text(employee.name),
      subtitle: Text(employee.email),
    ),
  );

  Stream<List<Employee>> getEmployee() => FirebaseFirestore.instance
      .collection('employee')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Employee.fromJson(doc.data())).toList());
}