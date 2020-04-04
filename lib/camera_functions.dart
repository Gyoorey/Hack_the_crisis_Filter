import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class CameraFunctions {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isRecording = false;
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  String video = "";
  String audio = "";
  String folder = "";
  String imageFolder = "";
  String audioFolder = "";
  String videoFolder = "";
  int counter = 0;
  final period = 5;
  bool isRunning = false;

  void initState() async {
    final cameras = await availableCameras();
    var firstCamera = cameras[0];
    for (var i = 0; i < cameras.length; i++) {
      if (cameras[i].lensDirection == CameraLensDirection.front) {
        firstCamera = cameras[i];
        break;
      }
    }
    // To display the current output from the Camera,
    // create a CameraController.
    this._controller = CameraController(
      // Get a specific camera from the list of available cameras.
      firstCamera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
  }

  Future<void> run() async {
    if(!isRunning) {
      Timer(Duration(seconds: 5), () {
        this.recordVideo();
      });
      isRunning = true;
    }
  }

  Future<void> stop() async {
    isRunning = false;
    if(isRecording) {
      isRecording = false;
      await _controller.stopVideoRecording();
      String command = "-i " + this.video + " -c copy " + this.audio;
      await _flutterFFmpeg.execute(command).then((rc) =>
          print("FFmpeg process exited with rc $rc"));
      //get frames from each second
      command = "-i " + this.video + " -vf fps=1 " + imageFolder + "/" +
          this.counter.toString() + "_%d.jpg";
      await _flutterFFmpeg.execute(command).then((rc) =>
          print("FFmpeg process exited with rc $rc"));
      this.counter++;
    }
  }

  void recordVideo() async {
    try {
      if(isRunning) {
        // Ensure that the camera is initialized.
        await _initializeControllerFuture;
        // Attempt to take a picture and log where it's been saved.
        if (!isRecording) {
          this.folder = (await getExternalStorageDirectory()).path;
          this.videoFolder = join(folder, "videos");
          this.audioFolder = join(folder, "audios");
          this.imageFolder = join(folder, "images");
          if (counter == 0) {
            await createDirectory(videoFolder, true);
            await createDirectory(audioFolder, true);
            await createDirectory(imageFolder, true);
          } else {
            await createDirectory(videoFolder, false);
            await createDirectory(audioFolder, false);
            await createDirectory(imageFolder, false);
          }
          //name of the next video file
          this.video =
              join(videoFolder, "video_" + this.counter.toString() + ".mp4");
          //name of the next audio file
          this.audio =
              join(audioFolder, "audio" + this.counter.toString() + ".aac");

          _controller.startVideoRecording(this.video);
          isRecording = true;
          //start a recording
          Timer(Duration(seconds: period), () {
            this.recordVideo();
          });
        } else {
          await _controller.stopVideoRecording();
          isRecording = false;
          //get audio channel
          String command = "-i " + this.video + " -c copy " + this.audio;
          await _flutterFFmpeg.execute(command).then((rc) =>
              print("FFmpeg process exited with rc $rc"));
          //get frames from each second
          command = "-i " + this.video + " -vf fps=1 " + imageFolder + "/" +
              this.counter.toString() + "_%d.jpg";
          await _flutterFFmpeg.execute(command).then((rc) =>
              print("FFmpeg process exited with rc $rc"));

          this.counter++;
          //sleep
          Timer(Duration(seconds: 1), () {
            this.recordVideo();
          });
        }
      }
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  Future<void> createDirectory(String name, bool delete) async {
    if (await Directory(name).exists()) {
      //we already have this, clean it
      if(delete) {
        await Directory(name).delete(recursive: true);
      }
      await Directory(name).create(recursive: true);
    } else { //if folder not exists create folder and then return its path
      await Directory(name).create(recursive: true);
    }
  }
}