import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State {
  void initState() {
    super.initState();
    loadUserSession();
  }

  Future<String> loadUserSession() async {
    String userId = await getUserIdFromPrefs();
    return userId;
  }

  Future<String> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? '';
  }

  File? imageFile;
  final imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/image/test.png'), fit: BoxFit.cover)),
      padding: EdgeInsets.only(top: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: new BoxDecoration(color: Colors.white),
            margin: const EdgeInsets.all(20),
            width: size.width,
            height: 250,
            child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                color: Color.fromRGBO(17, 0, 158, 1),
                strokeWidth: 1,
                dashPattern: const [5, 5],
                child: SizedBox.expand(
                  child: FittedBox(
                    child: imageFile != null
                        ? Image.file(File(imageFile!.path), fit: BoxFit.cover)
                        : const Icon(
                            Icons.image_outlined,
                            color: Color.fromRGBO(17, 0, 158, 1),
                          ),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 5),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: size.width,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(17, 0, 158, 1)),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      showPictureDialog();
                    },
                    child: const Center(
                      child: Text(
                        'Pick Image',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 5),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: size.width,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(17, 0, 158, 1)),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        imageFile = null;
                      });
                    },
                    child: const Center(
                      child: Text(
                        'Clear Image',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(40, 0, 40, 5),
          //   child: Material(
          //     elevation: 3,
          //     borderRadius: BorderRadius.circular(20),
          //     child: Container(
          //       width: size.width,
          //       height: 50,
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(20),
          //           color: Color.fromRGBO(17, 0, 158, 1)),
          //       child: Material(
          //         borderRadius: BorderRadius.circular(20),
          //         color: Colors.transparent,
          //         child: InkWell(
          //           splashColor: Colors.transparent,
          //           highlightColor: Colors.transparent,
          //           onTap: () async {
          //             uploadFileImage();
          //           },
          //
          //           child: const Center(
          //             child: Text(
          //               'Upload',
          //               style: TextStyle(
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: size.width,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(17, 0, 158, 1)),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      String userId = await loadUserSession();
                      Predict(userId);
                    },
                    child: const Center(
                      child: Text(
                        'Prediction',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> showPictureDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Action'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  getFromCamera();
                  Navigator.of(context).pop();
                },
                child: const Text('Open Camera'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  getFromGallery();
                  Navigator.of(context).pop();
                },
                child: const Text('Open Gallery'),
              ),
            ],
          );
        });
  }

  // get from gallery
  getFromGallery() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  // get from camera
  getFromCamera() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> Predict(String userid) async {
    sendJsonToFlask(userid);
    uploadFileImage();
  }

  Future<void> uploadFileImage() async {
    File imageFileUpload = File(imageFile!.path);
    String? fileName = imageFile?.path.split('/').last;

    String uploadEndpoint =
        "https://kgenz.site//uploadFileAndroid"; // Ganti dengan alamat server Flask yang sesuai
    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile!.path, filename: fileName),
    });

    try {
      Response response = await dio.post(uploadEndpoint, data: formData);
      if (response.data == 'sukses') {
        print('Upload berhasil: ${response.data}');
      } else {
        print('${response.data}');
      }
    } catch (e) {
      print('Error during upload: $e');
    }
  }

  Future<void> sendJsonToFlask(String userId) async {
    String? Stress;
    if (imageFile == null) {
      print('File gambar belum dipilih.');
      return;
    }

    String? fileName = imageFile?.path.split('/').last;
    if (fileName == null) {
      print('Gagal mendapatkan nama file.');
      return;
    }

    String apiUrl = "http://192.168.56.224:5000/receive_json";
    Dio dio = Dio();

    try {
      final Map<String, String> data = {
        'user_id': userId,
        'text': fileName,
      };

      // Menggunakan opsi `data` untuk mengirim data dalam format JSON
      final response = await dio.post(
        apiUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: jsonEncode(data),
      );

      // Periksa apakah respons server sukses
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData =
            response.data; // Use `response.data` for Dio
        String message = responseData['message'];

        // if (message == 4) {
        //   Stress = "Stress Tingkat Rendah";
        // } else if (message == 5 || message == 1) {
        //   Stress = "Stress Tingkat Sedang";
        // } else if (message == 2 || message == 0) {
        //   Stress = "2";
        // } else {
        //   Stress = "Tidak Ada Stress";
        // }
        _showAlertDialog(context, 'Tingkat Stress',
            'Stress yang Anda alami tingkat $message');
      } else {
        print('Permintaan gagal. Kode respons: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during request: $e');
    }
  }

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
}
