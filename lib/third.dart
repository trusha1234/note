import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note/data.dart';
import 'package:note/second_page.dart';
import 'package:note/trash.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

class third extends StatefulWidget {
  Database? database;

  int id;
  String title;
  String note;
  String textsize;
  int isbold;
  int isitalic;
  int isunderline;
  int tab_index;
  int super_index;
  int isappbar;
  int isbackground;
  int isicontheme;
  int background_index;
  int color_index;
  int themecolor;
  String s;

  third(
      this.database,
      this.id,
      this.title,
      this.note,
      this.textsize,
      this.isbold,
      this.isitalic,
      this.isunderline,
      this.tab_index,
      this.super_index,
      this.isappbar,
      this.isbackground,
      this.isicontheme,
      this.background_index,
      this.color_index,
      this.themecolor,
      this.s);

  @override
  State<third> createState() => _thirdState();
}

class _thirdState extends State<third> with TickerProviderStateMixin {
  String textsize = "14";
  bool isbold = false;
  bool isitalic = false;
  bool isunderline = false;
  int tab_index = 0;
  int super_index = 1;
  bool isappbar = false;
  bool isbackground = false;
  bool isicontheme = false; // white==false==0 && black==true==1
  int text_background_index = 0;
  int text_color_index = 2;
  int themecolor = 8;
  String note = "";
  String title = "No title";
  Color text_background = Colors.transparent;
  Color text_color = Colors.black87;
  TextEditingController text_control = TextEditingController();
  TextEditingController title_control = TextEditingController();
  TabController? tabController;
  Color colourthemeA = Colors.pink;
  DecorationImage? background_image;
  Image? appbar_image;

  List<bool> v = [];
  List<ListTile> llist = [];

  create_checkbox(int index) {
    v.add(false);
    llist.add(
      ListTile(
        leading: Checkbox(
            focusColor: Colors.amber,
            checkColor: Colors.black,
            activeColor: Colors.indigo,
            value: v[index],
            onChanged: <bool>(value) {
              v[index] = value;
              print("v[index] : ${v[index]}");
              print("value is : ${value}");

              setState(() {});
            }),
        title: TextField(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);

    if (widget.id >= 1) {
      title_control.text = widget.title;
      text_control.text = widget.note;

      textsize = widget.textsize;
      if (widget.isbold == 0) {
        isbold = false;
      } else {
        isbold = true;
      }
      if (widget.isitalic == 0) {
        isitalic = false;
      } else {
        isitalic = true;
      }
      if (widget.isunderline == 0) {
        isunderline = false;
      } else {
        isunderline = true;
      }
      tab_index = widget.tab_index;
      super_index = widget.super_index;
      if (widget.isappbar == 0) {
        isappbar = false;
      } else {
        isappbar = true;
      }
      if (widget.isbackground == 0) {
        isbackground = false;
      } else {
        isbackground = true;
      }
      if (widget.isicontheme == 0) {
        isicontheme = false;
      } else {
        isicontheme = true;
      }
      text_background_index = widget.background_index;
      text_color_index = widget.color_index;
      themecolor = widget.themecolor;
      note = widget.note;
      title = widget.title;
      text_background = data.colorlist[widget.background_index];
      text_color = data.colorlist[widget.color_index];
      tabController!.animateTo(widget.tab_index);

      List theme;
      if (widget.tab_index == 0) {
        theme = data.colour;
        colourthemeA = theme[widget.super_index];
      } else if (widget.tab_index == 1) {
        theme = data.artimage;
      } else if (widget.tab_index == 2) {
        theme = data.natureimage;
      } else if (widget.tab_index == 3) {
        theme = data.miniimage;
      } else {
        theme = data.loveimage;
      }
      if (widget.isbackground == 1) {
        background_image = DecorationImage(
            image: AssetImage(theme[widget.super_index]), fit: BoxFit.fill);
        appbar_image = null;
        colourthemeA = data.colourtheme[widget.themecolor];
      } else if (widget.isappbar == 1) {
        background_image = null;
        appbar_image = Image(
          image: AssetImage(theme[widget.super_index]),
          fit: BoxFit.fill,
        );
        colourthemeA = data.colourtheme[widget.themecolor];
      } else {
        background_image = null;
        appbar_image = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.s != "trash") {
          save();
        }
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0.5,
            iconTheme: IconThemeData(
              color: (isicontheme) ? Colors.black : Colors.white,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.navigate_before,
                size: 30,
              ),
            ),
            flexibleSpace: appbar_image,
            backgroundColor: colourthemeA,
            leadingWidth: 35,
            title: TextField(
              enabled: (widget.s == "edit" ||
                  widget.s == "" ||
                  widget.s == "checkbox")
                  ? true
                  : false,
              style:
              TextStyle(color: (isicontheme) ? Colors.black : Colors.white),
              controller: title_control,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "No title",
                  hintStyle: TextStyle(
                      color: (isicontheme) ? Colors.black : Colors.white)),
            ),
            actions: (widget.s == "edit" ||
                widget.s == "checkbox" ||
                widget.s == "")
                ? [
              IconButton(
                onPressed: () async {
                  save();
                },
                icon: Icon(Icons.save_outlined),
              ),
              PopupMenuButton(
                  position: PopupMenuPosition.under,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                  onSelected: (value) async {
                    if (value == 1) {
                    } else if (value == 2) {
                      // SHARE CODE HERE
                      String shr = text_control.text;
                      Share.share(shr);
                    } else if (value == 3) {
                      themes();
                    } else if (value == 4) {
                    } else {
                      // DELETE CODE AND MOVE TO TRASH CODE HERE
                      if (widget.id >= 1) {
                        note = text_control.text;
                        title = title_control.text;
                        if (title == "") {
                          title = "No title";
                        }
                        int bold = 0;
                        int underline = 0;
                        int italic = 0;
                        int appbar = 0;
                        int background = 0;
                        int icontheme = 0;
                        if (isbold) {
                          bold = 1;
                        } else {
                          bold = 0;
                        }
                        if (isunderline) {
                          underline = 1;
                        } else {
                          underline = 0;
                        }
                        if (isitalic) {
                          italic = 1;
                        } else {
                          italic = 0;
                        }
                        if (isappbar) {
                          appbar = 1;
                        } else {
                          appbar = 0;
                        }
                        if (isbackground) {
                          background = 1;
                        } else {
                          background = 0;
                        }
                        if (isicontheme) {
                          icontheme = 1;
                        } else {
                          icontheme = 0;
                        }
                        String qry =
                            "insert into trash values (null ,'${title}','${note}','${textsize}','${bold}','${italic}','${underline}','${tab_index}','${super_index}','${appbar}','${background}','${icontheme}','${text_background_index}','${text_color_index}','${themecolor}');";
                        int r_id;
                        r_id = await widget.database!.rawInsert(qry);

                        int? count;
                        String qry1;
                        count = Sqflite.firstIntValue(await widget
                            .database!
                            .rawQuery('SELECT COUNT(*) FROM note'));
                        print("count of note: ${count}");
                        if (count == 1) {
                          qry1 = "delete from note;";
                        } else {
                          qry1 =
                          "delete from note where id=${widget.id};";
                        }

                        int del_id;
                        del_id = await widget.database!.rawDelete(qry1);
                        print("r_id = ${r_id}");
                        if (r_id >= 1 && del_id == 1) {
                          Fluttertoast.showToast(
                              msg: "moved to trash!!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black54,
                              textColor: Colors.white,
                              fontSize: 16.0);

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return second(widget.database);
                                },
                              ));
                        }
                      }
                    }
                  },
                  itemBuilder: (context) => <PopupMenuEntry<Object>>[
                    PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        leading: Icon(
                          Icons.pin_drop_outlined,
                          size: 20,
                        ),
                        title: Text(
                          "Pin",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: ListTile(
                        leading: Icon(
                          Icons.shortcut,
                          size: 20,
                        ),
                        title: Text(
                          "Share",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: ListTile(
                        leading: Icon(
                          Icons.copy_all_outlined,
                          size: 20,
                        ),
                        title: Text(
                          "Themes",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: ListTile(
                        leading: Icon(
                          Icons.add_alert,
                          size: 20,
                        ),
                        title: Text(
                          "Reminder",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      value: 5,
                      child: ListTile(
                        leading: Icon(
                          Icons.delete_outline_outlined,
                          size: 20,
                          color: (widget.id >= 1)
                              ? Colors.red
                              : Colors.grey,
                        ),
                        title: Text(
                          "Delete",
                          style: TextStyle(
                              fontSize: 13,
                              color: (widget.id >= 1)
                                  ? Colors.red
                                  : Colors.grey),
                        ),
                      ),
                    ),
                  ]),
            ]
                : [
              IconButton(
                onPressed: () async {
                  int? count;
                  String qry;
                  count = Sqflite.firstIntValue(await widget.database!
                      .rawQuery('SELECT COUNT(*) FROM trash'));
                  print("count of trash//restore: ${count}");
                  if (count == 1) {
                    qry = "delete from trash;";
                  } else {
                    qry = "delete from trash where id=${widget.id};";
                  }
                  int del_id;
                  del_id = await widget.database!.rawDelete(qry);
                  if (del_id == 1) {
                    print("delete");
                  }
                  save();
                },
                icon: Icon(Icons.restore),
              ),
              IconButton(
                onPressed: () async {
                  int? count;
                  String qry;
                  count = Sqflite.firstIntValue(await widget.database!
                      .rawQuery('SELECT COUNT(*) FROM trash'));
                  print("count of trash//delete: ${count}");
                  if (count == 1) {
                    qry = "delete from trash;";
                  } else {
                    qry = "delete from trash where id=${widget.id};";
                  }

                  int del_id;
                  del_id = await widget.database!.rawDelete(qry);
                  if (del_id == 1) {
                    print("delete");
                  }
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return trash(widget.database);
                    },
                  ));
                },
                icon: Icon(Icons.delete_outline_outlined),
              ),
            ]
          // ],
        ),
        body: (widget.s == "checkbox")
            ? Container(
          height: double.infinity,
          child: ListView.builder(
            itemCount: llist.length + 1,
            itemBuilder: (context, index) {
              return (index != llist.length)
                  ? llist[index]
                  : ListTile(
                onTap: () {
                  create_checkbox(index);
                  setState(() {});
                },
                leading: Icon(Icons.add),
                title: Text(
                  "Add item...",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
          ),
        )
            : Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: background_image,
          ),
          padding: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.only(top: 100),
            child: TextField(
              enabled:
              (widget.s == "edit" || widget.s == "") ? true : false,
              controller: text_control,
              autofocus: false,
              style: TextStyle(
                  decoration:
                  (isunderline) ? TextDecoration.underline : null,
                  fontStyle: (isitalic) ? FontStyle.italic : null,
                  fontWeight: (isbold) ? FontWeight.bold : null,
                  fontSize: double.parse(textsize),
                  backgroundColor: text_background,
                  color: text_color),
              maxLength: 5000,
              keyboardType: TextInputType.multiline,
              maxLines: 100,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colourthemeA),
                  borderRadius: BorderRadius.circular(20),
                ),
                isCollapsed: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colourthemeA),
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: colourthemeA),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "No Content",
                hintStyle: TextStyle(color: text_color),
                filled: true,
                fillColor: colourthemeA.withOpacity(0.12),
                contentPadding:
                EdgeInsets.only(left: 15, right: 15, top: 15),
              ),
            ),
          ),
        ),
        bottomNavigationBar: (widget.s == "edit" || widget.s == "")
            ? Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  themes();
                },
                icon: Icon(Icons.color_lens_outlined),
              ),
              InkWell(
                onTap: () {
                  if (isbold) {
                    isbold = false;
                  } else {
                    isbold = true;
                  }
                  print("isbold = ${isbold}");
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: (isbold)
                              ? (colourthemeA == Colors.white ||
                              colourthemeA ==
                                  Colors.white.withOpacity(0.2))
                              ? Colors.lime
                              : colourthemeA
                              : Colors.black87),
                      color: (isbold)
                          ? (colourthemeA == Colors.white ||
                          colourthemeA ==
                              Colors.white.withOpacity(0.2))
                          ? Colors.lime.withOpacity(0.5)
                          : colourthemeA.withOpacity(0.2)
                          : null,
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(Icons.format_bold),
                ),
              ),
              InkWell(
                onTap: () {
                  if (isitalic) {
                    isitalic = false;
                  } else {
                    isitalic = true;
                  }
                  print("isitalic = ${isitalic}");
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: (isitalic)
                              ? (colourthemeA == Colors.white ||
                              colourthemeA ==
                                  Colors.white.withOpacity(0.2))
                              ? Colors.lime
                              : colourthemeA
                              : Colors.black87),
                      color: (isitalic)
                          ? (colourthemeA == Colors.white ||
                          colourthemeA ==
                              Colors.white.withOpacity(0.2))
                          ? Colors.lime.withOpacity(0.5)
                          : colourthemeA.withOpacity(0.2)
                          : null,
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(Icons.format_italic_outlined),
                ),
              ),
              InkWell(
                onTap: () {
                  if (isunderline) {
                    isunderline = false;
                  } else {
                    isunderline = true;
                  }
                  print("isunderlined = ${isunderline}");
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: (isunderline)
                              ? (colourthemeA == Colors.white ||
                              colourthemeA ==
                                  Colors.white.withOpacity(0.2))
                              ? Colors.lime
                              : colourthemeA
                              : Colors.black87),
                      color: (isunderline)
                          ? (colourthemeA == Colors.white ||
                          colourthemeA ==
                              Colors.white.withOpacity(0.2))
                          ? Colors.lime.withOpacity(0.5)
                          : colourthemeA.withOpacity(0.2)
                          : null,
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(Icons.format_underline_outlined),
                ),
              ),
              IconButton(
                onPressed: () {
                  //text background color
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          )),
                      builder: (context) {
                        return SizedBox(
                          height: 210,
                          width: 210,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Text Background Color",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Expanded(
                                  child: SizedBox(
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(
                                            right: 12,
                                            left: 12,
                                            top: 12,
                                            bottom: 12),
                                        itemCount: data.colorlist.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                text_background_index = index;
                                                text_background =
                                                data.colorlist[index];
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                  data.colorlist[index],
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset: Offset(3, 3),
                                                        blurRadius: 3,
                                                        color: Colors.black54)
                                                  ]),
                                            ),
                                          );
                                        },
                                        gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 7,
                                            mainAxisSpacing: 12,
                                            crossAxisSpacing: 12,
                                            childAspectRatio: 1)),
                                  ))
                            ],
                          ),
                        );
                      },
                      context: context);
                },
                icon: Icon(
                  Icons.texture_outlined,
                  size: 35,
                  color: (text_background == Colors.transparent)
                      ? Colors.black87
                      : text_background,
                ),
              ),
              IconButton(
                onPressed: () {
                  //textcolor

                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          )),
                      builder: (context) {
                        return SizedBox(
                          height: 210,
                          width: 210,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Text Color",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Expanded(
                                  child: SizedBox(
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(
                                            right: 12,
                                            left: 12,
                                            top: 12,
                                            bottom: 12),
                                        itemCount: data.colorlist.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (data.colorlist[index] ==
                                                    Colors.transparent) {
                                                  text_color = Colors.black54;
                                                  text_color_index = 2;
                                                } else {
                                                  text_color =
                                                  data.colorlist[index];
                                                  text_color_index = index;
                                                }
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                  data.colorlist[index],
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset: Offset(3, 3),
                                                        blurRadius: 3,
                                                        color: Colors.black54)
                                                  ]),
                                            ),
                                          );
                                        },
                                        gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 7,
                                            mainAxisSpacing: 12,
                                            crossAxisSpacing: 12,
                                            childAspectRatio: 1)),
                                  ))
                            ],
                          ),
                        );
                      },
                      context: context);
                },
                icon: Icon(
                  Icons.radio_button_checked_outlined,
                  color: (text_color == Colors.white)
                      ? Colors.black
                      : text_color,
                ),
              ),
              DropdownButton(
                  onChanged: (value) {
                    setState(() {
                      textsize = value as String;
                    });
                  },
                  value: textsize,
                  items: [
                    DropdownMenuItem(
                      child: Text(
                        "24",
                        style: TextStyle(fontSize: 24),
                      ),
                      value: "24",
                    ),
                    DropdownMenuItem(
                      child: Text(
                        "18",
                        style: TextStyle(fontSize: 18),
                      ),
                      value: "18",
                    ),
                    DropdownMenuItem(
                      child: Text(
                        "16",
                        style: TextStyle(fontSize: 16),
                      ),
                      value: "16",
                    ),
                    DropdownMenuItem(
                      child: Text(
                        "14",
                        style: TextStyle(fontSize: 14),
                      ),
                      value: "14",
                    ),
                    DropdownMenuItem(
                      child: Text(
                        "12",
                        style: TextStyle(fontSize: 12),
                      ),
                      value: "12",
                    ),
                    DropdownMenuItem(
                      child: Text(
                        "10",
                        style: TextStyle(fontSize: 10),
                      ),
                      value: "10",
                    ),
                  ])
            ],
          ),
        )
            : null,
      ),
    );
  }

  colour() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: data.colour.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            isappbar = false;
            isbackground = false;
            isicontheme = false;
            if (index == 0) {
              isicontheme = true;
            }

            text_color = Colors.black;
            appbar_image = null;
            background_image = null;
            tab_index = 0;
            super_index = index;
            colourthemeA = data.colour[index];
            setState(() {});
          },
          child: Container(
            height: 80,
            width: 60,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                image: DecorationImage(
                    image: AssetImage(data.colourimage[index]),
                    fit: BoxFit.fill)),
          ),
        );
      },
    );
  }

  art() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: data.artimage.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (index == 2 || index == 5) {
              isicontheme = true;
            } else {
              isicontheme = false;
            }

            appbar_image = null;
            colourthemeA = data.colourtheme[0];
            themecolor = 0;
            isappbar = false;
            isbackground = true;
            tab_index = 1;
            super_index = index;
            background_image = DecorationImage(
                image: AssetImage(data.artimage[index]), fit: BoxFit.fill);
            setState(() {});
          },
          child: Container(
            height: 80,
            width: 60,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              image: DecorationImage(
                  image: AssetImage(data.artimage[index]), fit: BoxFit.fill),
            ),
          ),
        );
      },
    );
  }

  nature() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: data.natureimage.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            tab_index = 2;
            super_index = index;
            if (index == 2) {
              isicontheme = true;
            } else {
              isicontheme = false;
            }
            if (index == 0) {
              colourthemeA = data.colourtheme[1];
              themecolor = 1;
            } else if (index == 1) {
              colourthemeA = data.colourtheme[2];
              themecolor = 2;
            } else if (index == 2) {
              colourthemeA = data.colourtheme[3];
              themecolor = 3;
            } else if (index == 3) {
              colourthemeA = data.colourtheme[4];
              themecolor = 4;
            } else if (index == 4) {
              colourthemeA = data.colourtheme[5];
              themecolor = 5;
            } else {
              colourthemeA = data.colourtheme[6];
              themecolor = 6;
            }
            appbar_image = Image(
              image: AssetImage(data.natureimage[index]),
              fit: BoxFit.fill,
            );
            isappbar = true;
            isbackground = false;
            background_image = null;
            setState(() {});
          },
          child: Container(
            height: 80,
            width: 60,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              image: DecorationImage(
                  image: AssetImage(data.natureimage[index]), fit: BoxFit.fill),
            ),
          ),
        );
      },
    );
  }

  minimalist() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: data.miniimage.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            tab_index = 3;
            super_index = index;

            if (index == 0 || index == 1 || index == 5) {
              text_color = Colors.white;
              colourthemeA = data.colourtheme[7];
              themecolor = 7;
              isicontheme = false;
            } else {
              text_color = Colors.black;
              colourthemeA = data.colourtheme[0];
              themecolor = 0;
              isicontheme = true;
            }
            appbar_image = null;
            isappbar = false;
            isbackground = true;
            background_image = DecorationImage(
                image: AssetImage(data.miniimage[index]), fit: BoxFit.fill);
            setState(() {});
          },
          child: Container(
            height: 80,
            width: 60,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              image: DecorationImage(
                  image: AssetImage(data.miniimage[index]), fit: BoxFit.fill),
            ),
          ),
        );
      },
    );
  }

  love() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: data.loveimage.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            tab_index = 4;
            super_index = index;
            if (index == 0 || index == 1 || index == 3) {
              isicontheme = false;
              appbar_image = null;
              isappbar = false;
              isbackground = true;
              colourthemeA = data.colourtheme[0];
              themecolor = 0;
              background_image = DecorationImage(
                  image: AssetImage(data.loveimage[index]), fit: BoxFit.fill);
            } else {
              isicontheme = true;
              background_image = null;
              isappbar = true;
              isbackground = false;
              colourthemeA = data.colourtheme[5];
              themecolor = 5;
              appbar_image = Image(
                image: AssetImage(data.loveimage[index]),
                fit: BoxFit.fill,
              );
            }

            setState(() {});
          },
          child: Container(
            height: 80,
            width: 60,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              image: DecorationImage(
                  image: AssetImage(data.loveimage[index]), fit: BoxFit.fill),
            ),
          ),
        );
      },
    );
  }

  themes() {
    return showModalBottomSheet(
        barrierColor: Colors.transparent,
        builder: (context) {
          return SizedBox(
            height: 210,
            width: 210,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text("Theme & Color"),
                ),
                TabBar(
                    unselectedLabelColor: Colors.black45,
                    controller: tabController,
                    labelColor: Colors.blue,
                    isScrollable: true,
                    tabs: [
                      Tab(
                        text: "Color",
                      ),
                      Tab(
                        text: "Art",
                      ),
                      Tab(
                        text: "Nature",
                      ),
                      Tab(
                        text: "Minimalist",
                      ),
                      Tab(
                        text: "Love",
                      ),
                    ]),
                Expanded(
                    child: TabBarView(controller: tabController, children: [
                      colour(),
                      art(),
                      nature(),
                      minimalist(),
                      love()
                    ]))
              ],
            ),
          );
        },
        context: context);
  }

  save() async {
    note = text_control.text;
    title = title_control.text;
    if (title == "") {
      title = "No title";
    }
    int bold = 0;
    int underline = 0;
    int italic = 0;
    int appbar = 0;
    int background = 0;
    int icontheme = 0;
    if (isbold) {
      bold = 1;
    } else {
      bold = 0;
    }
    if (isunderline) {
      underline = 1;
    } else {
      underline = 0;
    }
    if (isitalic) {
      italic = 1;
    } else {
      italic = 0;
    }
    if (isappbar) {
      appbar = 1;
    } else {
      appbar = 0;
    }
    if (isbackground) {
      background = 1;
    } else {
      background = 0;
    }
    if (isicontheme) {
      icontheme = 1;
    } else {
      icontheme = 0;
    }

    // UPDATE CODE HERE
    if (widget.id >= 1 && widget.s == "edit") {
      String qry =
          "update note set title='${title}',note='${note}',textsize='${textsize}',isbold='${bold}',isitalic='${italic}',isunderline='${underline}',tab_index='${tab_index}',super_index='${super_index}',isappbar='${appbar}',isbackground='${background}',isicontheme='${icontheme}',background_index='${text_background_index}',color_index='${text_color_index}',themecolor='${themecolor}' where id=${widget.id};";
      int r_id;
      r_id = await widget.database!.rawUpdate(qry);
      print("update id = ${r_id}");
      if (r_id == 1) {
        Fluttertoast.showToast(
            msg: "Saved!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return second(widget.database);
          },
        ));
      }
    }
    //INSERT CODE HERE
    else if (widget.s == "trash" || widget.s == "") {
      String qry =
          "insert into note values (null,'${title}','${note}','${textsize}','${bold}','${italic}','${underline}','${tab_index}','${super_index}','${appbar}','${background}','${icontheme}','${text_background_index}','${text_color_index}','${themecolor}');";
      int r_id;
      r_id = await widget.database!.rawInsert(qry);
      print("r_id = ${r_id}");
      if (r_id >= 1) {
        Fluttertoast.showToast(
            msg: "Saved!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return second(widget.database);
          },
        ));
      }
    }
  }
}
