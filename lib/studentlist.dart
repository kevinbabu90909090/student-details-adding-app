import 'dart:io';
import 'package:flutter/material.dart';
import 'package:week5/addStudent.dart';
import 'package:week5/model.dart';
import 'package:week5/queryFunction.dart';

class Studentlist extends StatefulWidget {
  const Studentlist({super.key});

  @override
  State<Studentlist> createState() => _StudentlistState();
}

class _StudentlistState extends State<Studentlist> {
  late List<Map<String, dynamic>> _studentData = [];
  TextEditingController _searchController = TextEditingController();

  @override
  initState() {
    super.initState();
    _fetchStudentsData();
  }

  Future<void> _fetchStudentsData() async {
    List<Map<String, dynamic>> students = await getAllStudents();
    if (_searchController.text.isNotEmpty) {
      students = students
          .where(
            (student) => student['name'].toString().contains(
                  _searchController.text.toLowerCase(),
                ),
          )
          .toList();
    }
    setState(() {
      _studentData = students;
    });
  }

  Future<void> _showEditDialog(int index) async {
    final student = _studentData[index];
    final TextEditingController nameController = TextEditingController(text: student['name']);
    final TextEditingController rollnoController = TextEditingController(text: student['rollno'].toString());
    final TextEditingController departmentController = TextEditingController(text: student['department']);
    final TextEditingController phonenoController = TextEditingController(text: student['phoneno'].toString());

    showDialog(
      context: context,
      builder: (BuildContext) => AlertDialog(
        title: const Text("Edit Student"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: rollnoController,
                decoration: const InputDecoration(labelText: "Roll No"),
              ),
              TextFormField(
                controller: departmentController,
                decoration: const InputDecoration(labelText: "Department"),
              ),
              TextFormField(
                controller: phonenoController,
                decoration: const InputDecoration(labelText: "Phone No"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await updatedStudent(
                StudentModel(
                  id: student['id'],
                  rollno: rollnoController.text,
                  name: nameController.text,
                  department: departmentController.text,
                  phoneno: phonenoController.text,
                  imageurl: student['imageurl'],
                ),
              );
              Navigator.of(context).pop();
              _fetchStudentsData(); // Refresh the list
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Changes Updated")));
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _showStudentDetailsDialog(Map<String, dynamic> student) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Student Details", style: TextStyle( fontWeight: FontWeight.bold),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Name: ${student['name']}"),
              ),
              ListTile(
                title: Text("Roll No: ${student['rollno']}"),
              ),
              ListTile(
                title: Text("Department: ${student['department']}"),
              ),
              ListTile(
                title: Text("Phone No: ${student['phoneno']}"),
              ),
              
            ],
          ),

          
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STUDENT LIST'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Container(
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(55),
                  borderSide: const BorderSide(),
                ),
              ),
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _fetchStudentsData();
                });
              },
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          final student = _studentData[index];
          final id = student['id'];
          final imageUrl = student['imageurl'];

          return ListTile(
            onTap: () {
              _showStudentDetailsDialog(student);
            },
            leading: GestureDetector(
              onTap: () {
                if (imageUrl != null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.file(File(imageUrl)),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
              child: CircleAvatar(
                backgroundImage: imageUrl != null ? FileImage(File(imageUrl)) : null,
                child: imageUrl == null ? const Icon(Icons.person) : null,
              ),
            ),
            title: Text('${student['name']}', style: const TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text(student['department']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _showEditDialog(index);
                  },
                  icon: const Icon(Icons.edit,),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext) => AlertDialog(
                        title: const Text("Delete Student"),
                        content: const Text("Are you sure you want to delete?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              await deleteStudent(id); // Delete the student
                              _fetchStudentsData(); // Refresh the list
                              Navigator.of(context).pop(); // Close the dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text("Deleted Successfully")));
                            },
                            child: const Text("Ok"),
                          )
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete,),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (ctx, index) {
          return const Divider();
        },
        itemCount: _studentData.length,
      ),


      
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Addstudent()))
                .then((value) => _fetchStudentsData());
          },
          icon: const Icon(Icons.person_add),
        ),
      ),
    );
  }
}
