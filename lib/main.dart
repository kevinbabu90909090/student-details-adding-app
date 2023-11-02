import 'package:flutter/material.dart';
import 'package:week5/queryFunction.dart';
import 'package:week5/studentlist.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const Myapp());
}
class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(

      home:  Studentlist(),
    );
  }
}
