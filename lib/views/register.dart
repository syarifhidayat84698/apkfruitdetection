import 'dart:convert';
import 'package:deteksibuah/views/api_baseurl.dart';
import 'package:http/http.dart' as http;
import 'package:deteksibuah/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String baseUrl = ApiEndpoints.baseUrl;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRetypeController =
      TextEditingController();

  Future<void> _signUp() async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _fullNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        're_password': _passwordRetypeController.text,
      }),
    );

    if (response.statusCode == 201) {
      Map<String, dynamic>? responseData = json.decode(response.body);

      if (responseData != null && responseData.containsKey('message')) {
        final String message = responseData['message'];
        _showSnackBar(message, Colors.green);
      } else {
        print('Invalid response data format');
        _showSnackBar('Format data respons tidak valid', Colors.red);
      }
    } else {
      print('Error: ${response.body}');
      _showSnackBar('Terjadi kesalahan. Silakan coba lagi nanti.', Colors.red);
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  Future<void> signUpWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final response = await http.post(
        Uri.parse('$base64Url/api/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': googleUser.email,
          'name': googleUser.displayName,
          'google_id': googleUser.id,
        }),
      );

      if (response.statusCode == 201) {
        _showSnackBar("Signup Berhasil", Colors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else if (response.statusCode == 200) {
        _showSnackBar("User sudah terdaftar", Colors.orange);
      } else {
        _showSnackBar("Gagal menyimpan data pengguna", Colors.red);
      }
    } on Exception catch (e) {
      print('exception->$e');
      _showSnackBar("Signup Gagal", Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showAlertDialog(String title, String content) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/test.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              child: Image.asset("assets/image/logobuah.png"),
              margin: EdgeInsets.only(top: 130),
            ),
            Container(
              child: Text(
                "Register",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Color.fromRGBO(17, 0, 158, 1),
                  fontFamily: 'LeagueSpartan',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              width: 320,
              child: TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              width: 320,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              width: 320,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              width: 320,
              child: TextField(
                controller: _passwordRetypeController,
                obscureText: true,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Re-type Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: 300,
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(17, 0, 158, 1),
                ),
                onPressed: () {
                  _signUp();
                },
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Container(
              child: Row(children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                      color: Colors.lightBlue[900],
                      height: 50,
                    ),
                  ),
                ),
                Text(
                  "OR",
                  style: TextStyle(
                    color: Colors.lightBlue[900],
                    fontSize: 20.0,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Divider(
                      color: Colors.lightBlue[900],
                      height: 50,
                    ),
                  ),
                ),
              ]),
            ),
            TextButton(
              onPressed: () {
                signUpWithGoogle();
                print("Sign in with Google pressed");
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              ),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/google_logo.png"),
                        height: 25.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 300,
                child: Row(
                  children: [
                    Text("already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.blue),
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
