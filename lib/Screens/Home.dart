import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/Screens/Description.dart';
import 'package:todo_list/Screens/add_task.dart';

class Home_screen extends StatefulWidget {
  const Home_screen({super.key});

  @override
  State<Home_screen> createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> {
  String? uid; // Use nullable String

  @override
  void initState() {
    getUid(); // No need to use setState here
    super.initState();
  }

  Future<void> getUid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = await auth.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
    }
  }

  Future<void> LogOut() async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Todo",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                LogOut();
                Fluttertoast.showToast(
                    msg: 'Logged Out',
                    backgroundColor: Colors.white,
                    textColor: Colors.black);
              },
              icon: Icon(
                Icons.login_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Tasks')
                .doc(uid)
                .collection('MyTasks')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final Docs = snapshot.data!.docs;
                List reversedDocs = Docs.reversed.toList();// Use snapshot.data.docs
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 55),
                  physics: BouncingScrollPhysics(),

                  itemCount: reversedDocs.length,
                  itemBuilder: (context, index) {
                    var timeString = reversedDocs[index]['Time'] as String;
                    var time = DateTime.parse(timeString);
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Description_Screen(
                                Title: reversedDocs[index]['Title'],
                                Description: reversedDocs[index]['Description'],
                              );
                            },
                          ));
                        },
                        child: Container(
                            height: 110,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 1, color: Colors.purple)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        reversedDocs[index]['Title'],
                                        style: TextStyle(fontSize: 22),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            Fluttertoast.showToast(
                                                msg: 'Data Deleted',
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black);
                                            await FirebaseFirestore.instance
                                                .collection('Tasks')
                                                .doc(uid)
                                                .collection('MyTasks')
                                                .doc(reversedDocs[index]['Time'])
                                                .delete();
                                          },
                                          icon: Icon(Icons.delete)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat().add_jm().format(time),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        DateFormat().add_yMd().format(time),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ),
                    );
                  },
                );
              }
            },
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Add_Task();
          }));
        },
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}


