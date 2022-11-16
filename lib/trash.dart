import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';

class trash extends StatefulWidget {
  Database? database;
  trash(this.database);



  @override
  State<trash> createState() => _trashState();
}

class _trashState extends State<trash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
