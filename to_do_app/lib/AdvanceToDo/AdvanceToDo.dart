import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:to_do_app/AdvanceToDo/databaseFile.dart';
import 'package:to_do_app/AdvanceToDo/requiredClasses.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_app/AdvanceToDo/userProfile.dart';

class HomeScreen extends StatefulWidget {
  final SingleModalUserData currUser;

  const HomeScreen({super.key, required this.currUser});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic database;

  List<SingleModalClass> data = [];

  List<Color> colors = const [
    Color.fromRGBO(250, 232, 232, 1),
    Color.fromRGBO(232, 237, 250, 1),
    Color.fromRGBO(250, 249, 232, 1),
    Color.fromRGBO(250, 232, 250, 1),
  ];

  List<String> imgList = const [
    "assets/toDo1.svg",
    "assets/toDo2.svg",
    "assets/toDo3.svg",
    "assets/toDo4.svg",
  ];

  final GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _date = TextEditingController();

  Future<void> initiateDatabase() async {
    database = await initialiseDatabase();
    await fetchInitialValues();
  }

  Future<void> fetchInitialValues() async {
    data = await fetchToDoData();
    setState(() {});
  }

  Future<void> insertToDoData(SingleModalClass obj) async {
    final localDB = await database;

    localDB.insert(
      "ToDoTable",
      obj.dataMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteToDoData(SingleModalClass obj) async {
    final localDb = await database;

    localDb.delete(
      "ToDoTable",
      where: "id = ?",
      whereArgs: [obj.id],
    );
  }

  Future<void> updateToDoData(SingleModalClass obj) async {
    final localDb = await database;

    await localDb.update(
      "ToDoTable",
      obj.dataMap(),
      where: "id = ?",
      whereArgs: [obj.id],
    );
  }

  Future<List<SingleModalClass>> fetchToDoData() async {
    final localDb = await database;

    List<Map<String, dynamic>> mapEntry = await localDb.query(
      "ToDoTable",
    );

    return List.generate(mapEntry.length, (i) {
      return SingleModalClass(
          id: mapEntry[i]["id"],
          title: mapEntry[i]["title"],
          description: mapEntry[i]["desc"],
          date: mapEntry[i]["date"],
          completed: mapEntry[i]["completed"]);
    });
  }

  @override
  void initState() {
    super.initState();
    initiateDatabase();
  }

  void showBottomSheet(bool doEdit, [SingleModalClass? singleModelObject]) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Form(
                key: _globalFormKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Create Task",
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Title",
                            style: GoogleFonts.quicksand(
                              textStyle: const TextStyle(
                                color: Color.fromRGBO(111, 81, 255, 1),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _title,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please enter Title";
                              } else {
                                return null;
                              }
                            },
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 0, 0, 0.7),
                            ),
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(111, 81, 255, 1)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(111, 81, 255, 1)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(111, 81, 255, 1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(111, 81, 255, 1)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Description",
                            style: GoogleFonts.quicksand(
                              textStyle: const TextStyle(
                                color: Color.fromRGBO(111, 81, 255, 1),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _description,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please enter dscription";
                              } else {
                                return null;
                              }
                            },
                            maxLines: 3,
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 0, 0, 0.7),
                            ),
                            decoration: const InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(111, 81, 255, 1),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(111, 81, 255, 1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(111, 81, 255, 1)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(111, 81, 255, 1)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Date",
                            style: GoogleFonts.quicksand(
                              textStyle: const TextStyle(
                                color: Color.fromRGBO(111, 81, 255, 1),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          TextFormField(
                              controller: _date,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please select date";
                                } else {
                                  return null;
                                }
                              },
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2025),
                                );
                                String formattedData =
                                    DateFormat.yMMMd().format(pickedDate!);

                                setState(() {
                                  _date.text = formattedData;
                                });
                              },
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(0, 0, 0, 0.7),
                              ),
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.calendar_month_outlined),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(111, 81, 255, 1),
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(111, 81, 255, 1)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(111, 81, 255, 1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(111, 81, 255, 1),
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  bool textFieldValidated =
                                      _globalFormKey.currentState!.validate();

                                  if (textFieldValidated) {
                                    doEdit
                                        ? submit(doEdit, singleModelObject)
                                        : submit(doEdit);
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 300,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Color.fromRGBO(111, 81, 255, 1),
                                  ),
                                  child: Text(
                                    "Submit",
                                    style: GoogleFonts.quicksand(
                                      textStyle: const TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void submit(bool doEdit, [SingleModalClass? singleModelObject]) async {
    if (_title.text.trim().isNotEmpty &&
        _description.text.trim().isNotEmpty &&
        _date.text.trim().isNotEmpty) {
      if (!doEdit) {
        SingleModalClass obj = SingleModalClass(
          title: _title.text.trim(),
          description: _description.text.trim(),
          date: _date.text.trim(),
          completed: 0,
        );

        await insertToDoData(obj);

        data = await fetchToDoData();

        setState(() {});
      } else {
        singleModelObject!.title = _title.text.trim();
        singleModelObject.description = _description.text.trim();
        singleModelObject.date = _date.text.trim();

        await updateToDoData(singleModelObject);
        data = await fetchToDoData();

        setState(() {});
      }
    }

    clearControllers();
  }

  void clearControllers() {
    _title.clear();
    _description.clear();
    _date.clear();
  }

  void removeTasks(SingleModalClass singleModalObject) {
    setState(() {
      data.remove(singleModalObject);
    });
  }

  void editTask(SingleModalClass singleModalObject) {
    _title.text = singleModalObject.title;
    _description.text = singleModalObject.description;
    _date.text = singleModalObject.date;

    showBottomSheet(true, singleModalObject);
  }

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _description.dispose();
    _date.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(111, 81, 255, 1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          clearControllers();
          showBottomSheet(false);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
              top: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    int pending = 0;
                    int completed = 0;

                    for (int i = 0; i < data.length; i++) {
                      if (data[i].completed == 1) completed++;
                    }

                    pending = data.length - completed;

                    ToDoInfo obj =
                        ToDoInfo(pending: "$pending", completed: "$completed");

                    Navigator.push(context,
                        MaterialPageRoute(builder: (contex) {
                      return UserProfile(currUser: widget.currUser, info: obj);
                    }));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color.fromARGB(132, 97, 94, 94),
                            width: 2)),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 35),
            child: Text(
              "Good Morning",
              style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 22),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 35),
            child: Text(
              widget.currUser.name,
              style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "CREATE TASKS",
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.only(top: 40, bottom: 40),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: ListView.separated(
                        itemCount: data.length,
                        separatorBuilder: ((context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        }),
                        itemBuilder: (contex, index) {
                          return Slidable(
                            closeOnScroll: true,
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              extentRatio: 0.2,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          editTask(data[index]);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  89, 57, 241, 1),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await deleteToDoData(data[index]);
                                          data = await fetchToDoData();
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  89, 57, 241, 1),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.15),
                                      offset: Offset(0, 0),
                                      blurRadius: 20),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                      width: 52,
                                      height: 52,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                      ),
                                      child: SvgPicture.asset(
                                        imgList[index % imgList.length],
                                        width: 35,
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data[index].title,
                                          style: GoogleFonts.inter(
                                            decoration:
                                                data[index].completed == 1
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 1),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          data[index].description,
                                          style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                              decoration:
                                                  data[index].completed == 1
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : TextDecoration.none,
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, .7),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          data[index].date,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Checkbox(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      activeColor: Colors.green,
                                      value: data[index].completed == 0
                                          ? false
                                          : true,
                                      onChanged: (val) async {
                                        data[index].completed == 0
                                            ? data[index].completed = 1
                                            : data[index].completed = 0;

                                        SingleModalClass obj = SingleModalClass(
                                          id: data[index].id,
                                          title: data[index].title,
                                          description: data[index].description,
                                          date: data[index].date,
                                          completed: data[index].completed,
                                        );

                                        await updateToDoData(obj);

                                        setState(() {});
                                      })
                                ],
                              ),
                            ),
                          );
                        }),
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
