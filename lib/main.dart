import 'package:flutter/material.dart';
//import 'package:learn_pagination/ui/home.dart';
import 'package:learn_pagination/ui/petaniPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Data Petani',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      home: PetaniPage(),
    );
  }
}
