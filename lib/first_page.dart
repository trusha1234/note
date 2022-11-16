import 'package:flutter/material.dart';
import 'package:note/second_page.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  Database? database;

  @override
  void initState() {
    super.initState();
    splash();
    create_db();
  }

  splash() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      Navigator.pushReplacement(this.context, MaterialPageRoute(
        builder: (context) {
          return second(database);
        },
      ));
    });
  }

  create_db() async {
// Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'note1.db');

// open the database
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE note (id INTEGER PRIMARY KEY AUTOINCREMENT , title TEXT, note TEXT, textsize TEXT, isbold INTEGER, isitalic INTEGER , isunderline INTEGER , tab_index INTEGER , super_index INTEGER , isappbar INTEGER , isbackground INTEGER , isicontheme INTEGER , background_index INTEGER , color_index INTEGER , themecolor INTEGER);');

      await db.execute(
          'CREATE TABLE trash (id INTEGER PRIMARY KEY AUTOINCREMENT , title TEXT, note TEXT, textsize TEXT, isbold INTEGER, isitalic INTEGER , isunderline INTEGER , tab_index INTEGER , super_index INTEGER , isappbar INTEGER , isbackground INTEGER , isicontheme INTEGER , background_index INTEGER , color_index INTEGER , themecolor INTEGER);');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("my_image/p1.jpg"), fit: BoxFit.fill)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                  child: SizedBox(
                child: Text(
                  "Super Note",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
                ),
              )),
            ],
          ),
          Text(
            "Notes and check list wherever you go",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "Loading.......",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    ));
  }
}
