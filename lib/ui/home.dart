import 'package:flutter/material.dart';
import 'package:learn_pagination/model/petani.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Petani> reports = [];
  @override
  void initState(){
    super.initState();
    // fetchPetani();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Report'),
    ),
    );
  }
}