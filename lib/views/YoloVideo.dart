// import 'package:flutter/material.dart';
// import 'package:flutter_vision/flutter_vision.dart';
// import 'package:camera/camera.dart';

// class YoloVideo extends StatefulWidget {
//   const YoloVideo({Key? key}) : super(key: key);

//   @override
//   State<YoloVideo> createState() => _YoloVideoState();
// }

// class _YoloVideoState extends State<YoloVideo> {
//   late CameraController controller;
//   late FlutterVision vision;
//   late List<Map<String, dynamic>> yoloResults;
//   CameraImage? cameraImage;
//   bool isLoaded = false;
//   bool isDetecting = false;
//   double confidenceThreshold = 0.5;

//   late List<CameraDescription> cameras;

//   Map<String, int> objectCounts = {}; // Map to store counts of detected objects

//   @override
//   void initState() {
//     super.initState();
//     init();
//   }

//   init() async {
//     cameras = await availableCameras();
//     vision = FlutterVision();
//     controller = CameraController(cameras[0], ResolutionPreset.low);
//     controller.initialize().then((value) {
//       loadYoloModel().then((value) {
//         setState(() {
//           isLoaded = true;
//           isDetecting = false;
//           yoloResults = [];
//         });
//       });
//     });
//   }

//   @override
//   void dispose() async {
//     super.dispose();
//     controller.dispose();
//     await vision.closeYoloModel();
//   }

//   Future<void> loadYoloModel() async {
//     await vision.loadYoloModel(
//         labels: 'assets/label.txt',
//         modelPath: 'assets/yolov8s_float32.tflite',
//         modelVersion: "yolov8",
//         numThreads: 1,
//         useGpu: true);
//     setState(() {
//       isLoaded = true;
//     });
//   }

//   Future<void> yoloOnFrame(CameraImage cameraImage) async {
//     final result = await vision.yoloOnFrame(
//         bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
//         imageHeight: cameraImage.height,
//         imageWidth: cameraImage.width,
//         iouThreshold: 0.4,
//         confThreshold: 0.4,
//         classThreshold: 0.5);
//     if (result.isNotEmpty) {
//       setState(() {
//         yoloResults = result;
//         updateObjectCounts();
//       });
//     }
//   }

//   void updateObjectCounts() {
//     objectCounts.clear();
//     for (var result in yoloResults) {
//       String tag = result['tag'];
//       if (objectCounts.containsKey(tag)) {
//         objectCounts[tag] = objectCounts[tag]! + 1;
//       } else {
//         objectCounts[tag] = 1;
//       }
//     }
//   }

//   Future<void> startDetection() async {
//     setState(() {
//       isDetecting = true;
//     });
//     if (controller.value.isStreamingImages) {
//       return;
//     }
//     await controller.startImageStream((image) async {
//       if (isDetecting) {
//         cameraImage = image;
//         yoloOnFrame(image);
//       }
//     });
//   }

//   Future<void> stopDetection() async {
//     setState(() {
//       isDetecting = false;
//       yoloResults.clear();
//       objectCounts.clear();
//     });
//   }

//   List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
//     if (yoloResults.isEmpty) return [];
//     double factorX = screen.width / (cameraImage?.height ?? 1);
//     double factorY = screen.height / (cameraImage?.width ?? 1);

//     Color colorPick = const Color.fromARGB(255, 50, 233, 30);

//     return yoloResults.map((result) {
//       double objectX = result["box"][0] * factorX;
//       double objectY = result["box"][1] * factorY;
//       double objectWidth = (result["box"][2] - result["box"][0]) * factorX;
//       double objectHeight = (result["box"][3] - result["box"][1]) * factorY;

//       return Positioned(
//         left: objectX,
//         top: objectY,
//         width: objectWidth,
//         height: objectHeight,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//             border: Border.all(color: Colors.pink, width: 2.0),
//           ),
//           child: Text(
//             "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(1)}%",
//             style: TextStyle(
//               background: Paint()..color = colorPick,
//               color: const Color.fromARGB(255, 115, 0, 255),
//               fontSize: 18.0,
//             ),
//           ),
//         ),
//       );
//     }).toList();
//   }

//   Widget displayObjectCounts() {
//     return Positioned(
//       top: 10,
//       left: 10,
//       child: Container(
//         color: Colors.black54,
//         padding: EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: objectCounts.entries.map((entry) {
//             return Text(
//               "${entry.key}: ${entry.value}",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;

//     if (!isLoaded) {
//       return Scaffold(
//         body: Center(
//           child: Text("Model not loaded, waiting for it"),
//         ),
//       );
//     }
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           AspectRatio(
//             aspectRatio: controller.value.aspectRatio,
//             child: CameraPreview(
//               controller,
//             ),
//           ),
//           ...displayBoxesAroundRecognizedObjects(size),
//           displayObjectCounts(),
//           Positioned(
//             bottom: 75,
//             width: MediaQuery.of(context).size.width,
//             child: Container(
//               height: 80,
//               width: 80,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                     width: 5, color: Colors.white, style: BorderStyle.solid),
//               ),
//               child: isDetecting
//                   ? IconButton(
//                       onPressed: () async {
//                         await stopDetection();
//                       },
//                       icon: const Icon(
//                         Icons.stop,
//                         color: Colors.red,
//                       ),
//                       iconSize: 50,
//                     )
//                   : IconButton(
//                       onPressed: () async {
//                         await startDetection();
//                       },
//                       icon: const Icon(
//                         Icons.play_arrow,
//                         color: Colors.white,
//                       ),
//                       iconSize: 50,
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class YoloVideo extends StatefulWidget {
  const YoloVideo({Key? key}) : super(key: key);

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  late CameraController controller;
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  double confidenceThreshold = 0.5;

  late List<CameraDescription> cameras;

  Map<String, int> objectCounts = {}; // Map to store counts of detected objects

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    cameras = await availableCameras();
    vision = FlutterVision();
    controller = CameraController(cameras[0], ResolutionPreset.low);
    controller.initialize().then((value) {
      loadYoloModel().then((value) {
        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    await vision.closeYoloModel();
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
        labels: 'assets/label.txt',
        modelPath: 'assets/modelfruit_float32.tflite',
        modelVersion: "yolov8",
        numThreads: 1,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.5);
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
        updateObjectCounts();
        sendDetectionResultsToAPI(); // Send results to API
      });
    }
  }

  void updateObjectCounts() {
    objectCounts.clear();
    for (var result in yoloResults) {
      String tag = result['tag'];
      if (objectCounts.containsKey(tag)) {
        objectCounts[tag] = objectCounts[tag]! + 1;
      } else {
        objectCounts[tag] = 1;
      }
    }
  }

  Future<void> sendDetectionResultsToAPI() async {
    final url = Uri.parse(
        'https://4762-2404-c0-7550-00-2-1c85-16a8.ngrok-free.app/save-detection'); // Replace with your Flask server IP and port

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'timestamp': DateTime.now().toIso8601String(),
        'counts': objectCounts,
      }),
    );

    if (response.statusCode == 200) {
      print('Detection results sent successfully');
    } else {
      print('Failed to send detection results');
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
      objectCounts.clear();
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      double objectX = result["box"][0] * factorX;
      double objectY = result["box"][1] * factorY;
      double objectWidth = (result["box"][2] - result["box"][0]) * factorX;
      double objectHeight = (result["box"][3] - result["box"][1]) * factorY;

      return Positioned(
        left: objectX,
        top: objectY,
        width: objectWidth,
        height: objectHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(1)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: const Color.fromARGB(255, 115, 0, 255),
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget displayObjectCounts() {
    return Positioned(
      top: 100,
      left: 10,
      child: Container(
        color: Colors.black54,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: objectCounts.entries.map((entry) {
            return Text(
              "${entry.key}: ${entry.value}",
              style: TextStyle(color: Colors.white, fontSize: 18),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (!isLoaded) {
      return Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(
              controller,
            ),
          ),
          ...displayBoxesAroundRecognizedObjects(size),
          displayObjectCounts(),
          Positioned(
            bottom: 75,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 5, color: Colors.white, style: BorderStyle.solid),
              ),
              child: isDetecting
                  ? IconButton(
                      onPressed: () async {
                        await stopDetection();
                      },
                      icon: const Icon(
                        Icons.stop,
                        color: Colors.red,
                      ),
                      iconSize: 50,
                    )
                  : IconButton(
                      onPressed: () async {
                        await startDetection();
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      iconSize: 50,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
