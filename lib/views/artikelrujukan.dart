import 'package:deteksibuah/views/profil.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class artikelRujukan extends StatelessWidget {
  const artikelRujukan({super.key});

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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Home()));
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Text(
                "Artikel",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.lightBlue[900]),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(40),
                      onTap: () {
                        // debugPrint('Card tapped.');
                        print("dsadasdasdsa");
                        _launchYouTubeURL();
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Gambar di samping kiri teks
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/image/caraatasisetres.jpg', // Ganti dengan URL gambar yang sesuai
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Teks di tengah
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Column(
                                  children: [
                                    Text(
                                      "Cara Atasi Stres Berkepanjangan",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Seperti istilah mensana incorpore sano, di dalam tubuh yang sehat tedapat jiwa ...",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(40),
                      onTap: () {
                        debugPrint('Card tapped.');
                        _launchYouTubeURL1();
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Gambar di samping kiri teks
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/image/carahilangkansetres.jpg', // Ganti dengan URL gambar yang sesuai
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Teks di tengah
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Column(
                                  children: [
                                    Text(
                                      "7 Cara Hadapi Setres               ",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Sobat Sehat, setuju gak kalo stress itu gak pernah lepas dari kehidupan kita semua? Mulai dari masalah di ...",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(40),
                      onTap: () {
                        debugPrint('Card tapped.');
                        _launchYouTubeURL2();
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Gambar di samping kiri teks
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/image/caramudahatasistres.jpg', // Ganti dengan URL gambar yang sesuai
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Teks di tengah
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Column(
                                  children: [
                                    Text(
                                      "Jangan Didiamkan, inilah 6 Cara Mudah Mengatasi Stres",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "Lagi stres? Jangan didiamin aja, ya! Soalnya, stres yang gak ditangani, apalagi sampai berlarut-larut, berpotensi ...",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(40),
                      onTap: () {
                        debugPrint('Card tapped.');
                        _launchYouTubeURL3();
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Gambar di samping kiri teks
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/image/caramengatasisetres.jpg', // Ganti dengan URL gambar yang sesuai
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Teks di tengah
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Column(
                                  children: [
                                    Text(
                                      "Stress Berkepanjangan? Coba Atasi Dengan Cara Ini",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "Stress merupakan reaksi tubuh terhadap situasi yang berbahaya atau dirasa berbahaya ...",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(40),
                      onTap: () {
                        debugPrint('Card tapped.');
                        _launchYouTubeURL4();
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Gambar di samping kiri teks
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/image/pengelolaansetres.jpg', // Ganti dengan URL gambar yang sesuai
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Teks di tengah
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Column(
                                  children: [
                                    Text(
                                      "Pengelolaan Stres 101 (Cara Mengurangi Stress berdasarkan Ilmu Psikologi)",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "Di era dimana banyak hal bisa ngebuat kita pusing dan stres, kita butuh belajar gimana ...",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchYouTubeURL() async {
    const youtubeURL =
        'https://www.youtube.com/watch?v=m1SUt24g2L0&ab_channel=CNNIndonesia';

    try {
      if (await canLaunch(youtubeURL)) {
        await launch(youtubeURL);
      } else {
        debugPrint('Could not launch $youtubeURL');
      }
    } catch (e) {
      debugPrint('Error launching YouTube URL: $e');
    }
  }

  void _launchYouTubeURL1() async {
    const youtubeURL =
        'https://www.youtube.com/watch?v=vj5hvNPzsxA&ab_channel=HelloSehat';

    try {
      if (await canLaunch(youtubeURL)) {
        await launch(youtubeURL);
      } else {
        debugPrint('Could not launch $youtubeURL');
      }
    } catch (e) {
      debugPrint('Error launching YouTube URL: $e');
    }
  }

  void _launchYouTubeURL2() async {
    const youtubeURL =
        'https://www.youtube.com/watch?v=htY0Z7SEYR4&ab_channel=Alodokter';

    try {
      if (await canLaunch(youtubeURL)) {
        await launch(youtubeURL);
      } else {
        debugPrint('Could not launch $youtubeURL');
      }
    } catch (e) {
      debugPrint('Error launching YouTube URL: $e');
    }
  }

  void _launchYouTubeURL3() async {
    const youtubeURL =
        'https://www.youtube.com/watch?v=pfW6mP_9qOA&ab_channel=SKWADHealth';

    try {
      if (await canLaunch(youtubeURL)) {
        await launch(youtubeURL);
      } else {
        debugPrint('Could not launch $youtubeURL');
      }
    } catch (e) {
      debugPrint('Error launching YouTube URL: $e');
    }
  }

  void _launchYouTubeURL4() async {
    const youtubeURL =
        'https://www.youtube.com/watch?v=4iPVQlKFvlM&ab_channel=SatuPersen-IndonesianLifeSchool';

    try {
      if (await canLaunch(youtubeURL)) {
        await launch(youtubeURL);
      } else {
        debugPrint('Could not launch $youtubeURL');
      }
    } catch (e) {
      debugPrint('Error launching YouTube URL: $e');
    }
  }
}
