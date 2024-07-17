import 'dart:convert';

import 'package:deteksibuah/views/api_baseurl.dart';
import 'package:deteksibuah/views/artikelrujukan.dart';
import 'package:deteksibuah/views/home_page.dart';
import 'package:deteksibuah/views/layanan.dart';
import 'package:deteksibuah/views/menu.dart';
import 'package:deteksibuah/views/profil.dart';
import 'package:deteksibuah/views/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// import 'history_page.dart'; // Import halaman history

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home()));
}

class Home extends StatefulWidget {
  // const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String baseUrl = ApiEndpoints.baseUrl;

  void _showAlertDialog(BuildContext context, String title, String content) {
    // Membuat AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Tutup alert
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    );

    // Menampilkan AlertDialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> saveUserSession(
      String userId, String fullName, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', userId);
    prefs.setString('full_name', fullName);
    prefs.setString('email', email);
  }

  //forgot password
  Future<void> _forgotPassword() async {
    final TextEditingController forgotPasswordController =
        TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: TextField(
            controller: forgotPasswordController,
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.post(
                  Uri.parse('$baseUrl/forgot_password'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                    'email': forgotPasswordController.text,
                  }),
                );

                Navigator.pop(context);

                if (response.statusCode == 200) {
                  _showSnackBar(
                      context,
                      'Email untuk reset password telah dikirim!',
                      Colors.green);
                } else {
                  print('Error: ${response.body}');
                  _showSnackBar(
                      context,
                      'Terjadi kesalahan. Silakan coba lagi nanti.',
                      Colors.red);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic>? responseData = json.decode(response.body);

      if (responseData != null && responseData.containsKey('token_access')) {
        final String accessToken = responseData['token_access'];

        _showSnackBar(context, 'Login berhasil!', Colors.green);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Beranda()),
        );
      } else {
        print('Invalid response data format');
        _showSnackBar(context, 'Format data respons tidak valid', Colors.red);
      }
    } else if (response.statusCode == 400) {
      print('Invalid email or password');
      _showSnackBar(context, 'Email atau Password salah', Colors.red);
    } else {
      print('Error: ${response.body}');
      _showSnackBar(
          context, 'Terjadi kesalahan. Silakan coba lagi nanti.', Colors.red);
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  Future<dynamic> signInWithGoogle(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Kirim data pengguna ke API Flask
        final response = await http.post(
          Uri.parse('$baseUrl/api/save_user'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': user.email ?? '', // Pastikan email tidak null
            'name': user.displayName ?? '', // Pastikan displayName tidak null
            'google_id': user.uid
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          final Map<String, dynamic> responseDataGoogle =
              jsonDecode(response.body);
          saveSession(
              responseDataGoogle['token_access'],
              responseDataGoogle['user_id'],
              responseDataGoogle['name'],
              responseDataGoogle['email']);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Login Berhasil, ${user.displayName ?? 'User'}!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Layanan()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Gagal menyimpan data pengguna"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ));
        }
      }

      return userCredential;
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login Gagal"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/image/test.png"),
                  fit: BoxFit.cover),
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Text("adasad"),
                  ),
                  Container(
                    child: Image.asset("assets/image/logobuah.png"),
                    margin: EdgeInsets.only(top: 150),
                  ),
                  Container(
                    child: Text(
                      "Memudahkan anda untuk menghitung Buah",
                      style: TextStyle(fontSize: 14),
                    ),
                    margin: EdgeInsets.only(top: 5),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    width: 250,
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      width: 250,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[350]),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      width: 250,
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                      )),
                  GestureDetector(
                    onTap: () {
                      _forgotPassword();
                    },
                    child: Text(
                      'Forget password?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 250,
                    child: Center(
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              children: [
                                // Container(
                                //   child: const Align(
                                //     alignment: Alignment.topLeft,
                                //     child: Text("Don't have an account?"),
                                //
                                //   )
                                // ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Text("Don't Have An Account?"),
                                      ),
                                      Container(
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Register()));
                                          },
                                          child: Text(
                                            "Sign up",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.lightBlue[900]),
                              onPressed: _login,
                              child: Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                              color: Colors.lightBlue[900],
                              height: 50,
                            )),
                      ),
                      Text(
                        "OR",
                        style: TextStyle(
                            color: Colors.lightBlue[900], fontSize: 20.0),
                      ),
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Divider(
                              color: Colors.lightBlue[900],
                              height: 50,
                            )),
                      ),
                    ]),
                  ),
                  TextButton(
                    onPressed: () {
                      signInWithGoogle(context);
                      print("Sign in with Google pressed");
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.zero),
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
                  )
                ],
              ),

              // Foreground widget here
            )));
  }
}

Future<void> saveSession(
    String token_access, String userId, String name, String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token_access', token_access);
  await prefs.setString('user_id', userId);
  await prefs.setString('name', name);
  await prefs.setString('email', email);
}

void _logout(BuildContext context) async {
  String baseUrl = ApiEndpoints.baseUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('token_access');

  try {
    // Sign out from Firebase
    await _auth.signOut();

    // Sign out from Google
    await googleSignIn.signOut();

    String? accessToken = prefs.getString('token_access');
    if (accessToken != null) {
      final url = Uri.parse('$baseUrl/logout');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        // Clear local storage
        await prefs.remove('user_id');
        await prefs.remove('token_access');
        await prefs.remove('name');
        await prefs.remove('email');

        // Show sign out success snackbar
        _showSnackBar(context, 'Sign out successful', Colors.green);

        // Navigate to WelcomeScreen or any other desired screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        // Show server sign out error snackbar
        _showSnackBar(context, 'Failed to logout from server', Colors.red);
      }
    } else {
      // Clear local storage
      await prefs.remove('user_id');
      await prefs.remove('name');
      await prefs.remove('email');

      // Show sign out success snackbar
      _showSnackBar(context, 'Sign out successful', Colors.green);

      // Navigate to WelcomeScreen or any other desired screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  } catch (error) {
    // Show sign out error snackbar
    _showSnackBar(
        context, 'Error signing out. Please try again later.', Colors.red);
  }
}

void _showSnackBar(BuildContext context, String message, Color color) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  void _showAlertDialog(BuildContext context, String title, String content) {
    // Membuat AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Tutup alert
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    );

    // Menampilkan AlertDialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/image/logobuah.png",
          height: 40,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white, // Ganti warna sesuai kebutuhan
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              // Log out user
              _logout(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.exit_to_app,
                color: Colors.lightBlue[900],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Profil()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.person,
                color: Colors.lightBlue[900], // Ganti warna sesuai kebutuhan
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      "Fruit Detection & Counting",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'LeagueSpartan',
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(17, 0, 158, 1),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "\\",
                      style: TextStyle(
                          color: Color.fromRGBO(17, 0, 158, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  decoration: new BoxDecoration(
                      color: Color.fromRGBO(242, 242, 243, 1)),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Image.asset("assets/image/buahberanda.webp"),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "------>",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 25),
                        ),
                      ),
                      Container(
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 0, 0, 0)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Layanan()));
                          },
                          child: Text(
                            "Lanjut Ke Halaman Selanjutnya",
                            style: TextStyle(
                                color: Color.fromRGBO(247, 247, 247, 1)),
                          ),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );

    // );
  }
}
