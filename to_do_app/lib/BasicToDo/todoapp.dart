import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SingleModalClass {
  String title;
  String description;
  String date;

  SingleModalClass(
      {required this.title, required this.description, required this.date});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State {
  List<SingleModalClass> data1 = [];

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
                                color: Color.fromRGBO(2, 167, 177, 1),
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
                                    color: Color.fromRGBO(0, 139, 148, 1)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 139, 148, 1)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(0, 139, 148, 1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 139, 148, 1)),
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
                                color: Color.fromRGBO(0, 139, 148, 1),
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
                                  color: Color.fromRGBO(0, 139, 148, 1),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 139, 148, 1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 139, 148, 1)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 139, 148, 1)),
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
                                color: Color.fromRGBO(0, 139, 148, 1),
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
                                    color: Color.fromRGBO(0, 139, 148, 1),
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 139, 148, 1)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 139, 148, 1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 139, 148, 1),
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
                                onTap: () {
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
                                    color: Color.fromRGBO(0, 139, 148, 1),
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

  void submit(bool doEdit, [SingleModalClass? singleModelObject]) {
    if (_title.text.trim().isNotEmpty &&
        _description.text.trim().isNotEmpty &&
        _date.text.trim().isNotEmpty) {
      if (!doEdit) {
        setState(() {
          data1.add(SingleModalClass(
            title: _title.text.trim(),
            description: _description.text.trim(),
            date: _date.text.trim(),
          ));
        });
      } else {
        setState(() {
          singleModelObject!.title = _title.text.trim();
          singleModelObject.description = _description.text.trim();
          singleModelObject.date = _date.text.trim();
        });
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
      data1.remove(singleModalObject);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          clearControllers();
          showBottomSheet(false);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(2, 167, 177, 1),
        title: Text(
          "To-do list",
          style: GoogleFonts.quicksand(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: const Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: ListView.builder(
          itemCount: data1.length,
          itemBuilder: (context, index) {
            return Animate(
              effects: [FadeEffect(), SlideEffect()],
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: Color.fromRGBO(0, 0, 0, 0.1)),
                  ],
                  color: colors[index % colors.length],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    color: Color.fromRGBO(0, 0, 0, .07)),
                              ],
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                            child: SvgPicture.asset(
                                imgList[index % imgList.length])),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data1[index].title,
                                style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromRGBO(0, 0, 0, 1),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                data1[index].description,
                                style: GoogleFonts.quicksand(
                                  textStyle: const TextStyle(
                                    color: Color.fromRGBO(84, 84, 84, 1),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          data1[index].date,
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(132, 132, 132, 1),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                editTask(data1[index]);
                              },
                              child: const Icon(
                                Icons.edit_outlined,
                                color: Color.fromRGBO(2, 167, 177, 1),
                                size: 23,
                              ),
                            ),
                            const SizedBox(
                              width: 19,
                            ),
                            GestureDetector(
                              onTap: () {
                                removeTasks(data1[index]);
                              },
                              child: const Icon(
                                Icons.delete_outline,
                                color: Color.fromRGBO(2, 167, 177, 1),
                                size: 23,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
