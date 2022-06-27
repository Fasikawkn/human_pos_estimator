import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

class CustomCamera extends StatefulWidget {
  const CustomCamera(
      {required this.cameras,
      required this.setRecognitions,
      Key? key})
      : super(key: key);
  final List<CameraDescription> cameras;
  final Function(List<dynamic> list, int height, int width) setRecognitions;

  @override
  State<CustomCamera> createState() => _CustomCameraState();
}

class _CustomCameraState extends State<CustomCamera> {
  late CameraController _cameraController;
  bool _isDetecting = false;
  @override
  void initState() {
    _initializeCamera();
    super.initState();
  }

  _initializeCamera() {
    if (widget.cameras.isEmpty) {
      debugPrint('No Camera is found');
    } else {
      _cameraController = CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
      );

      _cameraController.initialize().then(
        (value) {
          if (mounted) {
            setState(() {});
            _cameraController.startImageStream((image) async {
              if (!_isDetecting) {
                _isDetecting = true;

                var _recognition = await Tflite.runPoseNetOnFrame(
                  bytesList: image.planes.map((plane) {
                    return plane.bytes;
                  }).toList(),
                  imageHeight: image.height,
                  imageWidth: image.width,
                  numResults: 1,
                );

                widget.setRecognitions(
                  _recognition!,
                  image.height,
                  image.width,
                );

                _isDetecting = false;
              }
            });
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _cameraController.stopImageStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    if (!_cameraController.value.isInitialized) {
      return Container();
    }
    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = _cameraController.value.previewSize!;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(
        _cameraController,
      ),
    );
  }
}
