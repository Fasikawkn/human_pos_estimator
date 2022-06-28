import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:human_pos_estimator/camera.dart';
import 'package:human_pos_estimator/detector_box.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

class PoseEstimator extends StatefulWidget {
  const PoseEstimator(this.cameras, {Key? key}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<PoseEstimator> createState() => _PoseEstimatorState();
}

class _PoseEstimatorState extends State<PoseEstimator> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;

  _loadModel() async {
     await Tflite.loadModel(
      model: 'assets/posenet_mv1_075_float_from_checkpoints.tflite',
      numThreads: 3
    );
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  void initState() {
   if(mounted){
      _loadModel();
   }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            CustomCamera(
              cameras: widget.cameras,
              setRecognitions: setRecognitions,
            ),
            DetectorBox(
              results: _recognitions,
              previewH: math.max(_imageHeight, _imageWidth),
              previewW: math.min(_imageHeight, _imageWidth),
              screenH: screen.height,
              screenW: screen.width,
            ),
            Positioned(
              top: 0.0,
              left: 10.0,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
