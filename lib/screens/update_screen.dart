import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late List<String> fields = [];
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var field in fields) {
      _controllers[field] = TextEditingController();
    }
  }

  void fetchDocument(String docId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('students')
        .doc(docId)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      fields = data.keys.toList();

      for (String field in fields) {
        _controllers[field] =
            TextEditingController(text: data[field]?.toString() ?? '');
      }

      setState(() {});
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
      setState(() {
        isVisible = false;
      });
    }
  }

  bool isVisible = false;
  final TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Page'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: TextFormField(
              controller: _idController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                labelText: 'Student ID',
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_idController.text.trim().isNotEmpty) {
                    fetchDocument(_idController.text.trim());
                    setState(() {
                      isVisible = true;
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
                });
              },
              child: const Text("Select Student")),
          Expanded(
            child: ListView.builder(
              itemCount: fields.length,
              itemBuilder: (context, index) {
                String field = fields[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: TextFormField(
                    controller: _controllers[field],
                    decoration: InputDecoration(
                      labelText: field,
                    ),
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: isVisible,
            child: ElevatedButton(
                onPressed: () {
                  DocumentReference docRef = FirebaseFirestore.instance
                      .collection('students')
                      .doc(_idController.text.trim());
                  Map<String, dynamic> data = {
                    for (String field in fields)
                      field: _controllers[field]!.text.trim(),
                  };
                  docRef.update(data);
                  Navigator.pop(context);
                },
                child: const Text("Update")),
          ),
        ],
      ),
    );
  }
}
