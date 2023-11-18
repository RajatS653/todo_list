import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Add_Task extends StatefulWidget {
  const Add_Task({super.key});

  @override
  State<Add_Task> createState() => _Add_TaskState();
}

class _Add_TaskState extends State<Add_Task> {
  TextEditingController TitleController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();

  AddTaskToFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = await FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    var Time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('Tasks')
        .doc(uid)
        .collection('MyTasks')
        .doc(Time.toString())
        .set({
      'Title': TitleController.text,
      'Description': DescriptionController.text,
      'Time': Time.toString()
    });
    Fluttertoast.showToast(msg: 'Data Added', backgroundColor: Colors.white, textColor: Colors.black);
    FocusScope.of(context).unfocus();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("New Task"),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children:[ Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          child: Column(
            children: [
              Container(
                child: TextField(
                  controller: TitleController,
                  decoration: InputDecoration(
                      labelText: "Enter Title", border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: TextField(
                  controller: DescriptionController,
                  decoration: InputDecoration(
                      labelText: "Enter Description",
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        AddTaskToFirebase();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Add Task",
                        style: TextStyle(fontSize: 20),
                      )))
            ],
          ),
        ),
        ]
      ),
    );
  }
}
