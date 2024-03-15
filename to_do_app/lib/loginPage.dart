import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/todoapp.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //hardcoded username and password

  bool flag = true;
  String _username = "sandy";
  String _password = "123";

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_username == _usernameController.text.trim() &&
          _password == _passwordController.text) {
        _showSuccessSnackbar();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red, // Change background color
            behavior: SnackBarBehavior.floating, // Set behavior to floating

            margin: EdgeInsets.only(
                top: 70, left: 20, right: 20, bottom: 20), // Adjust margin
            content:
                Text('Login Failed', style: TextStyle(color: Colors.white)),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void clearControllers() {
    _usernameController.text = "";
    _passwordController.text = "";
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
        content: Text('Logged in Successfully',
            style: TextStyle(color: Colors.white)),
        duration: Duration(seconds: 1),
      ),
    );

    clearControllers();

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset("assets/loginImg2.gif"),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Login",
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 139, 148, 1),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 28,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _usernameController,
                            style: const TextStyle(
                                color: Color.fromRGBO(0, 139, 148, 1)),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              hintText: "Username",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: flag,
                            style: const TextStyle(
                                color: Color.fromRGBO(0, 139, 148, 1)),
                            obscuringCharacter: "•",
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.key),
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      flag = !flag;
                                    });
                                  },
                                  icon: const Icon(
                                      Icons.remove_red_eye_outlined)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            style: const ButtonStyle(
                              fixedSize: MaterialStatePropertyAll(Size(0, 45)),
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromRGBO(0, 139, 148, 1),
                              ),
                            ),
                            onPressed: _submitForm,
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
