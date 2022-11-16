import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:note/data.dart';
import 'package:note/third.dart';
import 'package:note/trash.dart';
import 'package:sqflite_common/sqlite_api.dart';

class second extends StatefulWidget {
  Database? database;

  second(this.database);

  @override
  State<second> createState() => _secondState();
}

class _secondState extends State<second> {
  Future get_data() async {
    print("this is app");
    List<Map> list;
    String qry = 'select * from note;';
    list = await widget.database!.rawQuery(qry);
    print("list of get_data(): ${list}");
    if (list.isEmpty) {
      return null;
    } else {
      return list;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(onPressed: () {}, icon: Icon(Icons.settings_outlined)),
        title: Text(
          "SUPERE NOTE",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.cloud_upload_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.bakery_dining)),
          PopupMenuButton(
            onSelected: (value) {
              if (value == "3") {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return trash(widget.database);
                  },
                ));
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<Object>>[
              PopupMenuItem(
                  value: "1",
                  child: ListTile(
                    leading: Icon(Icons.grid_view),
                    title: Text("View by grid"),
                  )),
              PopupMenuItem(
                  value: "2",
                  child: ListTile(
                    leading: Icon(Icons.copy_outlined),
                    title: Text("color & Background"),
                  )),
              PopupMenuItem(
                  value: "3",
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text("Trash"),
                  )),
              PopupMenuItem(
                  value: "4",
                  child: ListTile(
                    leading: Icon(Icons.settings_outlined),
                    title: Text("Setting"),
                  )),
              PopupMenuItem(
                  value: "5",
                  child: ListTile(
                    leading: Icon(Icons.question_mark_outlined),
                    title: Text("FAQ"),
                  )),
              PopupMenuItem(
                  value: "6",
                  child: ListTile(
                    leading: Icon(Icons.sentiment_very_satisfied_rounded),
                    title: Text("more App"),
                  )),
              PopupMenuDivider(),
              PopupMenuItem(
                  value: "7",
                  child: ListTile(
                    leading: Icon(Icons.business_center_outlined),
                    title: Text("Buy VIP"),
                  ))
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: get_data(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Map> temp;
            if (snapshot.hasData) {
              temp = snapshot.data as List<Map>;
              return ListView.builder(
                itemCount: temp.length,
                itemBuilder: (context, index) {
                  Map m = temp[index];
                  DecorationImage? dec;
                  Color? c;
                  List one;
                  if (m['tab_index'] == 0) {
                    one = data.colour;
                    c = one[m['super_index']];
                    c = c!.withOpacity(0.5);
                    dec = null;
                  } else if (m['tab_index'] == 1) {
                    one = data.artimage;
                  } else if (m['tab_index'] == 2) {
                    one = data.natureimage;
                  } else if (m['tab_index'] == 3) {
                    one = data.miniimage;
                  } else {
                    one = data.loveimage;
                  }
                  if (m['isbackground'] == 1 || m['isappbar'] == 1) {
                    dec = DecorationImage(
                        image: AssetImage(one[m['super_index']]),
                        fit: BoxFit.fitWidth);
                    c = null;
                  }
                  return Card(
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        image: dec,
                        color: c,
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return third(
                                  widget.database,
                                  m['id'],
                                  m['title'],
                                  m['note'],
                                  m['textsize'],
                                  m['isbold'],
                                  m['isitalic'],
                                  m['isunderline'],
                                  m['tab_index'],
                                  m['super_index'],
                                  m['isappbar'],
                                  m['isbackground'],
                                  m['isicontheme'],
                                  m['background_index'],
                                  m['color_index'],
                                  m['themecolor'],
                                  "edit");
                            },
                          ));
                        },
                        title: Text(
                          "${m['title']}",
                          style: TextStyle(
                              color: (m['isicontheme'] == 0)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        subtitle: Text(
                          "${m['note']}",
                          maxLines: 1,
                          style: TextStyle(
                              color: (m['isicontheme'] == 0)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        leading: SizedBox(
                          height: 50,
                          width: 50,
                          child: Image(
                            image: AssetImage("my_image/pencil.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  "No Data Yet",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: SpeedDial(
        elevation: 10,
        icon: Icons.add,
        iconTheme: IconThemeData(size: 30),
        activeIcon: Icons.close_rounded,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        activeBackgroundColor: Colors.white,
        activeForegroundColor: Colors.blueAccent,
        children: [
          SpeedDialChild(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return third(widget.database, 0, "", "", "", 0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0, 0, "");
                  },
                ));
              },
              label: "Note",
              child: Icon(Icons.edit_note_outlined)),
          SpeedDialChild(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return third(widget.database, 0, "", "", "", 0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0, 0, "");
                  },
                ));
              },
              label: "Checklist",
              child: Icon(Icons.checklist)),
        ],
      ),
    );
  }
}
