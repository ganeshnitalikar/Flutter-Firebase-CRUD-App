import 'package:crud_app_with_ui/screens/create_screen.dart';
import 'package:crud_app_with_ui/screens/read_screen.dart';
import 'package:crud_app_with_ui/screens/update_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _idController = TextEditingController();

  deleteStudent() {
    final dialog = AlertDialog(
      title: const Text("Delete Student"),
      content: TextFormField(
        controller: _idController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Student ID",
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            CollectionReference cr =
                FirebaseFirestore.instance.collection("students");
            if (_idController.text.trim() != "") {
              cr.doc(_idController.text).delete();
              _idController.clear();
              Navigator.pop(context);
            }
          },
          child: const Text("Delete Student"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Select Operation  ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              myBtn(
                  text: "Create ",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateScreen()));
                  }),
              myBtn(
                  text: "Read ",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReadScreen()));
                  }),
              myBtn(
                  text: "Update ",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateScreen()));
                  }),
              myBtn(
                  text: "Delete ",
                  onPressed: () {
                    deleteStudent();
                  }),
            ],
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.78,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("students")
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      return GestureDetector(
                        onTap: () {
                          //add new screen which will show all the details of the student
                          print("Tapped");
                        },
                        child: ListView(
                          children: snapshot.data.docs.map<Widget>((document) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                isThreeLine: true,
                                title: Text("Student Id : ${document['id']}"),
                                subtitle: Text(
                                    "Name: ${document['firstName']} ${document['lastName']}\n"
                                    "Branch: ${document['branch']}\n"),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget myBtn({required String text, required Function onPressed}) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            onPressed();
          },
          child: Container(
            height: 50,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ));
  }
}
