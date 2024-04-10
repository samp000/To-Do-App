import 'package:to_do_app/AdvanceToDo/databaseFile.dart';
import 'package:to_do_app/AdvanceToDo/registerPage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_app/AdvanceToDo/AdvanceToDo.dart';

import 'package:to_do_app/AdvanceToDo/requiredClasses.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobNo = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool flag = true;
  dynamic database;
  List<SingleModalUserData> data = [];

  SingleModalUserData currUser = SingleModalUserData(
    name: "User",
    mobileNo: "123",
    password: "123",
  );

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
      data = await fetchUserData();

      bool flg = false;

      for (int i = 0; i < data.length; i++) {
        if (data[i].mobileNo == _mobNo.text.trim() &&
            data[i].password == _password.text) {
          flg = true;
          currUser = data[i];
          break;
        }
      }

      if (flg) {
        _showSuccessSnackbar(currUser);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
            content: Text('Invalid Login Credentials',
                style: TextStyle(color: Colors.white)),
            duration: Duration(milliseconds: 500),
          ),
        );
      }
    }
  }

  void _showSuccessSnackbar(SingleModalUserData currUser) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
        content: Text('Logged in Successfully',
            style: TextStyle(color: Colors.white)),
        duration: Duration(milliseconds: 500),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(currUser: currUser)),
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
                SvgPicture.asset("assets/login.svg",
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width * 10 / 100),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                      "Login",
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
                      controller: _mobNo,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: "Mobile Number",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter mobile no';
                        }
                        return null;
                      }),
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
                      controller: _password,
                      obscureText: flag,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: const OutlineInputBorder(),
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
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password ';
                        }
                        return null;
                      }),
                ),
                const SizedBox(
                  height: 30,
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
                      "Login",
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
                        builder: (contex) => const Register(),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Dont have any Account ?   "),
                        Text(
                          "Register",
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
