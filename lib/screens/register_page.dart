import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  bool loading = false;
  var apiService = ApiService();
  void register() async {
    setState(() {
      loading = true;
    });
    final response = await apiService.registerUser(
        usernameController.text, emailController.text, passwordController.text);
    if (response.statusCode == 200) {
      print('User registered successfully.');
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: "User registered successfully");
    } else {
      setState(() {
        loading = false;
      });
      print('Error in user registration.');
      Fluttertoast.showToast(
        msg: "Login failed: ${response.body}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM, // Position of the toast
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Register')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(style: TextStyle(fontSize: 24), "Register"),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(label: Text('Username')),
                keyboardType: TextInputType.name,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(label: Text('Email')),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(label: Text('Password')),
                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: register, child: Text('Register')),
                  SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login-user');
                      },
                      child: Text("Login"))
                ],
              )
            ],
          ),
        ));
  }
}
