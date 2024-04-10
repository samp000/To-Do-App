import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_app/AdvanceToDo/databaseFile.dart';
import 'package:to_do_app/AdvanceToDo/loginPage.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:to_do_app/AdvanceToDo/requiredClasses.dart';

dynamic database;

class Register extends StatefulWidget {
  const Register({super.key});
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobilController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool flag = true;

  Future<void> insertUserData(SingleModalUserData obj) async {
    final localDB = await database;

    localDB.insert(
      "UserData",
      obj.getUserMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SingleModalUserData>> fetchUserData() async {
    final localDb = await database;

    List<Map<String, dynamic>> mapEntry = await localDb.query(
      "UserData",
    );

    return List.generate(mapEntry.length, (i) {
      return SingleModalUserData(
        id: mapEntry[i]["id"],
        name: mapEntry[i]["name"],
        mobileNo: mapEntry[i]["mobileNo"],
        password: mapEntry[i]["password"],
      );
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      SingleModalUserData obj = SingleModalUserData(
          name: _nameController.text,
          mobileNo: _mobilController.text,
          password: _passwordController.text);

      await insertUserData(obj);
      _showSuccessSnackbar();
    } else {}
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
        content: Text('Registration Successfull',
            style: TextStyle(color: Colors.white)),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    database = initialiseDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SvgPicture.asset("assets/register.svg",
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width * 10 / 100),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width -
                      MediaQuery.of(context).size.width * 10 / 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Name';
                        }
                        return null;
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width -
                      MediaQuery.of(context).size.width * 10 / 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: TextFormField(
                      controller: _mobilController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: "Mobile No",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Mobile No';
                        }
                        return null;
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width -
                      MediaQuery.of(context).size.width * 10 / 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: TextFormField(
                      obscureText: flag,
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              flag = !flag;
                            });
                          },
                          icon: flag
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Password';
                        }
                        return null;
                      }),
                ),
                const SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    _submitForm();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width * 10 / 100,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 126, 40, 141),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (contex) => const Login(),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have Account !  "),
                        Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue[800]),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
