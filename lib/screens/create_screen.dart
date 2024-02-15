import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  validate() {
    if (_firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _ageController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _idController.text.trim().isNotEmpty &&
        _branchController.text.trim().isNotEmpty &&
        _semesterController.text.trim().isNotEmpty &&
        _rollNoController.text.trim().isNotEmpty) {
      return true;
    }
    return false;
  }

  createStudent() {
    if (validate()) {
      FirebaseFirestore.instance
          .collection("students")
          .doc(_idController.text.trim())
          .set(
        {
          "firstName": _firstNameController.text.trim(),
          "lastName": _lastNameController.text.trim(),
          "age": _ageController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(),
          "id": _idController.text.trim(),
          "branch": _branchController.text.trim(),
          "semester": _semesterController.text.trim(),
          "rollNo": _rollNoController.text.trim(),
        },
      ).whenComplete(() => Navigator.pop(context));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("All fields are required"),
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

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Add New Student"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              myTextField(
                controller: _firstNameController,
                hintText: "First Name",
              ),
              const SizedBox(
                height: 20,
              ),
              myTextField(
                controller: _lastNameController,
                hintText: "Last Name",
              ),
              const SizedBox(
                height: 20,
              ),
              myTextField(
                controller: _ageController,
                hintText: "Age",
              ),
              const SizedBox(
                height: 20,
              ),
              myTextField(
                controller: _emailController,
                hintText: "Email",
              ),
              const SizedBox(
                height: 20,
              ),
              myTextField(
                controller: _phoneController,
                hintText: "Phone",
              ),
              const SizedBox(
                height: 20,
              ),
              myTextField(controller: _idController, hintText: "ID"),
              const SizedBox(
                height: 20,
              ),
              myTextField(
                controller: _branchController,
                hintText: "Branch",
              ),
              const SizedBox(
                height: 20,
              ),
              myTextField(
                controller: _semesterController,
                hintText: "Semester",
              ),
              const SizedBox(
                height: 20,
              ),
              myTextField(
                controller: _rollNoController,
                hintText: "Roll No",
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  createStudent();
                },
                child: const Text("Add Student"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myTextField(
      {required TextEditingController controller, required String hintText}) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black12, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
