import 'package:deteksibuah/views/WebViewExample.dart';
import 'package:deteksibuah/views/YoloVideo.dart';
import 'package:deteksibuah/views/api_baseurl.dart';
import 'package:deteksibuah/views/artikelrujukan.dart';
import 'package:deteksibuah/views/chabot.dart';
import 'package:deteksibuah/views/home_page.dart';
import 'package:deteksibuah/main.dart';
import 'package:deteksibuah/views/menudeteksi.dart';
import 'package:deteksibuah/views/profil.dart';
import 'package:deteksibuah/views/sentimen_analisis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

class Layanan extends StatelessWidget {
  const Layanan({super.key});

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
                  color: Colors.lightBlue[900], // Ganti warna sesuai kebutuhan
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
            child: Container(
          child: GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                alignment: Alignment.center,
                child: Image.asset("assets/image/tanganhp.png"),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 50),
                      alignment: Alignment.center,
                      child: Text(
                        "menunjukkan kecakapan chat bot dalam berkomunikasi",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(17, 0, 158, 1)),
                      ),
                    ),
                    Container(
                      width: 180,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.lightBlue[900]),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatBotPanel()));
                        },
                        child: Text(
                          "Open Chatbot",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 45),
                      alignment: Alignment.center,
                      child: Text(
                        "Fruit Detection & counting",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(17, 0, 158, 1)),
                      ),
                    ),
                    Container(
                      width: 180,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.lightBlue[900]),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => menudeteksi()));
                        },
                        child: Text(
                          "Open Detection",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                alignment: Alignment.center,
                child: Image.asset("assets/image/buahberanda.webp"),
              ),
              Container(
                  margin: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Image.asset("assets/image/human.png")),
              Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 50),
                      alignment: Alignment.center,
                      child: Text(
                        " Artikel ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(17, 0, 158, 1)),
                      ),
                    ),
                    Container(
                      width: 180,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.lightBlue[900]),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => artikelRujukan()));
                        },
                        child: Text(
                          "Open Artikel",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // margin: EdgeInsets.all(5),
                // alignment: Alignment.center,
                // child:
                // Text("Rekomendasi Artikel dan Latihan Relaksasi", textAlign: TextAlign.center,style: TextStyle(
                //     fontSize: 15,
                //     fontWeight: FontWeight.bold,
                //     color: Color.fromRGBO(17, 0, 158, 1)
                // ),),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 45),
                      alignment: Alignment.center,
                      child: Text(
                        "Visualisasi Data",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(17, 0, 158, 1)),
                      ),
                    ),
                    Container(
                      width: 180,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.lightBlue[900]),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => WebViewExample()));
                        },
                        child: Text(
                          "Open Strimlit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                alignment: Alignment.center,
                child: Image.asset("assets/image/analisis1.png"),
              ),
            ],
          ),
        )));
  }
}
