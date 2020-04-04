import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera3/camera_functions.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {

  const TakePictureScreen({
    Key key
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  //This is the camera controller object  --Gyuri
  CameraFunctions cam;


  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    // Next, initialize the controller. This returns a Future.

    //create a new camera object  --Gyuri
    cam = CameraFunctions();
    cam.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    //Dispose the camera object  --Gyuri
    cam.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //The periodic camera recordings start running from here, later cam.stop() should be invoked to stop this
    //functionality  --Gyuri
    cam.run();
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        builder: (context, snapshot) {
          //place your layout here!  --Gyuri
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }



}
