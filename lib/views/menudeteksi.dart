import 'package:deteksibuah/core.dart';
import 'package:deteksibuah/views/WebViewvidio.dart';
import 'package:flutter/material.dart';

class menudeteksi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Deteksi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Aksi untuk tombol pertama
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => YoloVideo()));
              },
              child: Text('Deteksi Realtime'),
            ),
            SizedBox(height: 20), // Jarak antara dua tombol
            ElevatedButton(
              onPressed: () {
                // Aksi untuk tombol kedua
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WebViewvidio()));
              },
              child: Text('Deteksi vidio'),
            ),
          ],
        ),
      ),
    );
  }
}
