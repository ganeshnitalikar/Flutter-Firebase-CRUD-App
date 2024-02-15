import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key});

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  final TextEditingController _idController = TextEditingController();
  bool _isData = false;

  readData() {
    if (_idController.text.trim().isNotEmpty) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("students")
          .doc(_idController.text.trim());

      documentReference.get().then((snapshot) {
        if (snapshot.exists) {
          setState(() {
            _isData = true;
          });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: const Text("Student ID does not exist"),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"),
                    ),
                  ],
                );
              });
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Student ID is required"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Student ID "),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _idController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Student ID",
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              readData();
            },
            child: const Text("Read Data"),
          ),
          const SizedBox(
            height: 20,
          ),
          _isData
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("students")
                      .doc(_idController.text.trim())
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      children: [
                        Text(
                            "Name: ${snapshot.data["firstName"]} ${snapshot.data["lastName"]}"),
                        Text("Age: ${snapshot.data["age"]}"),
                        Text("ID: ${snapshot.data["id"]}"),
                        Text("Email : ${snapshot.data["email"]}"),
                        Text("Roll No : ${snapshot.data["rollNo"]}"),
                        Text("Phone : ${snapshot.data["phone"]}"),
                        Text("Branch : ${snapshot.data["branch"]}"),
                        Text("Semester : ${snapshot.data["semester"]}"),
                      ],
                    );
                  },
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
