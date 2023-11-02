
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:week5/model.dart';
import 'package:week5/queryFunction.dart';


class Addstudent extends StatefulWidget {
  @override
  State<Addstudent> createState() => _AddstudentState();
}

class _AddstudentState extends State<Addstudent> {
  


  final _studentname = TextEditingController();
  final _rollno=TextEditingController();
  final _department=TextEditingController();
  final _phoneno=TextEditingController();
  String? _selectedImage;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              centerTitle: true,
              title: const Text('STUDENT INFORMATION'),
            ),

            const SizedBox(height: 30,),
            
            CircleAvatar(
              radius: 50,
                 
                  child: GestureDetector(
                      onTap: () async {
                        String? pickimage = await _pickImageFromCamera();
                        setState(() {
                          _selectedImage = pickimage;
                        });
                      },
                      child: _selectedImage != null
                          ? ClipOval(
                              child: Image.file(
                                File(_selectedImage!),
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              ),
                            )
                          : const Icon(
                              Icons.add_a_photo,
                              
                            )),
              
            ),
            const SizedBox(height: 20,),
            Form(
             key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [

                    TextFormField( 
                      controller: _studentname,
                      decoration: InputDecoration(
                        hintText: 'Student Name',
                        prefixIcon:const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a name';
                        }
                        return null;
                      },
                    ),


                    const SizedBox(height: 20,),


                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _rollno,
                      validator: (value) {
                        if(value!.isEmpty){
                          return 'enter roll no.';
                        }
                         return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Roll No.',
                        prefixIcon:const Icon(Icons.format_list_numbered),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),


                    const SizedBox(height: 20,),


                    TextFormField(
                      controller: _department,
                      validator: (value) {
                        if(value!.isEmpty){
                          return 'Choose your deparment';
                        }return null;
                      },
                      decoration: InputDecoration(
                       prefixIcon:const Icon(Icons.school),
                        hintText: 'Department',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),


                    const SizedBox(height: 20,),


                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _phoneno,
                      validator: (value) {
                        if(value!.isEmpty){
                          return 'enter phone number';
                        }return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        hintText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ),


            const SizedBox(height: 15,),



            ElevatedButton.icon(
              onPressed: ()async {
               
                if (_formKey.currentState!.validate()) {
                  
                  
                if(_selectedImage==null){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("plz select a image"),),);
                    
                }else{
                  final student = StudentModel(
                        rollno: _rollno.text,
                        name: _studentname.text,
                        department: _department.text,
                        phoneno: _phoneno.text,
                        imageurl: _selectedImage ?? '',
                      );
                   
                    await addstudent(student).then((value){
                          if(value>0){
                            ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(20),
                          content: Text('Data added successfully'),
                        ));

                          }else{
                            ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(20),
                          content: Text('Unable to add data'),
                        ));
                          }
                        });
                        _studentname.clear();
                        _department.clear();
                        _phoneno.clear();
                        _rollno.clear();
                        setState(() {
                          _selectedImage = null;
                        });
                        Navigator.pop(context);
                }        
               }  
              },
              icon: const Icon(Icons.save),
              label: const Text('SAVE'),
            ),
          ],
        ),
      ),
    );
  }

   // immage uploading funtion//
 
}
   Future<String?> _pickImageFromCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return pickedImage.path;
    }
    return null;
  }