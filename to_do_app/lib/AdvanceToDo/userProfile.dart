import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do_app/AdvanceToDo/databaseFile.dart';
import 'package:to_do_app/AdvanceToDo/requiredClasses.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfile extends StatefulWidget {
  final SingleModalUserData currUser;
  final ToDoInfo info;

  const UserProfile({super.key, required this.currUser, required this.info});

  @override
  State<UserProfile> createState() {
    return _UserProfileState();
  }
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController _password = TextEditingController(text: "password");
  FocusNode _focusNode = FocusNode();

  bool edit = false;
  dynamic database;

  @override
  void initState() {
    super.initState();
    database = initialiseDatabase();
    _focusNode.addListener(_onFocusChanged);
  }

  Future<void> _onFocusChanged() async {
    widget.currUser.password = _password.text;

    if (!_focusNode.hasFocus) {
      SingleModalUserData obj = SingleModalUserData(
        id: widget.currUser.id,
        name: widget.currUser.name,
        mobileNo: widget.currUser.mobileNo,
        password: _password.text,
      );

      await updateUserData(obj);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.purple,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
          content:
              Text('Password changed', style: TextStyle(color: Colors.white)),
          duration: Duration(milliseconds: 700),
        ),
      );
    }
  }

  Future<void> updateUserData(SingleModalUserData obj) async {
    final localDb = await database;

    await localDb.update(
      "UserData",
      obj.getUserMap(),
      where: "id = ?",
      whereArgs: [obj.id],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, border: Border.all(width: 2)),
              child: ClipOval(
                child: Image.network(
                  "https://i.pinimg.com/280x280_RS/79/dd/11/79dd11a9452a92a1accceec38a45e16a.jpg",
                  width: 100,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.currUser.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Mobile No:",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.currUser.mobileNo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: 260,
              child: TextFormField(
                readOnly: !edit,
                obscureText: !edit,
                controller: _password,
                focusNode: _focusNode,
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(0, 0, 0, 0.7),
                ),
                decoration: InputDecoration(
                  label: const Text("Change Password"),
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      edit = !edit;
                      _password.text = widget.currUser.password;
                      setState(() {});
                    },
                    child: const Icon(Icons.edit),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(111, 81, 255, 1)),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(111, 81, 255, 1)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(111, 81, 255, 1),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(111, 81, 255, 1)),
                  ),
                ),
                onEditingComplete: () async {
                  widget.currUser.password = _password.text;
                  SingleModalUserData obj = SingleModalUserData(
                    id: widget.currUser.id,
                    name: widget.currUser.name,
                    mobileNo: widget.currUser.mobileNo,
                    password: _password.text,
                  );

                  await updateUserData(obj);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.purple,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                          top: 70, left: 20, right: 20, bottom: 20),
                      content: Text('Password changed',
                          style: TextStyle(color: Colors.white)),
                      duration: Duration(milliseconds: 700),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Row(children: [
                Text(
                  "Task Statistics",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ]),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(88, 0, 0, 0),
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 0.3),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: const Column(
                          children: [
                            Icon(Icons.pending_actions),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Pending Tasks",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.info.pending,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(88, 0, 0, 0),
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 0.3),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: const Column(
                          children: [
                            Icon(Icons.check_circle_outline),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Completed Tasks",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.info.completed,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
