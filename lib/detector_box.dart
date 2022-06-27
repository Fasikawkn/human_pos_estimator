import 'dart:ui';
import 'package:flutter/material.dart';


class DetectorBox extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  const DetectorBox(
      {required this.results,
      required this.previewH,
      required this.previewW,
      required this.screenH,
      required this.screenW,
      Key? key})
      : super(key: key);

  Map<String, Offset> _getPoints(Size screen) {
    Map<String, Offset> _values = {};
    for (var result in results) {
      var keyValues = result['keypoints'].values;
      for (var keysPoint in keyValues) {
        var _x = keysPoint["x"];
        var _y = keysPoint["y"];
        var scaleW, scaleH, x, y;

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          var difW = (scaleW - screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          y = _y * scaleH;
        } else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;
          x = _x * scaleW;
          y = (_y - difH / 2) * scaleH;
        }

        _values[keysPoint["part"]] = Offset(x - 6, y - 6);
      }
    }

    return _values;
  }

  List<Widget> _renderNames() {
    var lists = <Widget>[];
    for (var re in results) {
      var list = re["keypoints"].values.map<Widget>((k) {
        var _x = k["x"];
        var _y = k["y"];
        var scaleW, scaleH, x, y;

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          var difW = (scaleW - screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          y = _y * scaleH;
        } else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;
          x = _x * scaleW;
          y = (_y - difH / 2) * scaleH;
        }
        return Positioned(
          left: x - 6,
          top: y - 6,
          width: 100,
          height: 20,
          child: Text(
            "${k["part"]}",
            style: const TextStyle(
              color: Color.fromRGBO(37, 213, 253, 1.0),
              fontSize: 12.0,
            ),
          ),
        );
      }).toList();

      lists.addAll(list);
    }

    return lists;
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        CustomPaint(
          painter: KeYPainter(_getPoints(_screenSize)),
        ),
        Stack(
          children: _renderNames(),
        )
      ],
    );
  }
}

class KeYPainter extends CustomPainter {
  final Map<String, Offset> offsets;
  const KeYPainter(this.offsets);

  @override
  void paint(Canvas canvas, Size size) {
    if (offsets.isNotEmpty) {
      Offset nose = offsets['nose']!;
      Offset leftEye = offsets['leftEye']!;
      Offset rightEye = offsets['rightEye']!;
      Offset leftEar = offsets['leftEar']!;
      Offset rightEar = offsets['rightEar']!;
      Offset leftShoulder = offsets['leftShoulder']!;
      Offset rightShoulder = offsets['rightShoulder']!;
      Offset leftElbow = offsets['leftElbow']!;
      Offset rightElbow = offsets['rightElbow']!;
      Offset leftWrist = offsets['leftWrist']!;
      Offset rightWrist = offsets['rightWrist']!;
      Offset leftHip = offsets['leftHip']!;
      Offset rightHip = offsets['rightHip']!;
      Offset leftKnee = offsets['leftKnee']!;
      Offset rightKnee = offsets['rightKnee']!;
      Offset leftAnkle = offsets['leftAnkle']!;
      Offset rightAnkle = offsets['rightAnkle']!;

      Paint _dotPaint = Paint()
        ..color = const Color.fromRGBO(37, 213, 253, 1.0)
        ..strokeCap = StrokeCap.round //rounded points
        ..strokeWidth = 6;

      canvas.drawPoints(
        PointMode.points,
        offsets.values.toList(),
        _dotPaint,
      );

      Paint _paintLine = Paint()
        ..color = const Color.fromRGBO(37, 213, 253, 1.0)
        ..strokeWidth = 2;

      canvas.drawLine(nose, leftEye, _paintLine);
      canvas.drawLine(nose, rightEye, _paintLine);
      canvas.drawLine(leftEye, leftEar, _paintLine);
      canvas.drawLine(rightEye, rightEar, _paintLine);

      canvas.drawLine(leftShoulder, rightShoulder, _paintLine);
      canvas.drawLine(leftHip, rightHip, _paintLine);
      canvas.drawLine(leftShoulder, leftHip, _paintLine);
      canvas.drawLine(rightShoulder, rightHip, _paintLine);

      canvas.drawLine(leftHip, leftKnee, _paintLine);
      canvas.drawLine(leftKnee, leftAnkle, _paintLine);
      canvas.drawLine(rightHip, rightKnee, _paintLine);
      canvas.drawLine(rightKnee, rightAnkle, _paintLine);

      canvas.drawLine(leftShoulder, leftElbow, _paintLine);
      canvas.drawLine(leftElbow, leftWrist, _paintLine);
      canvas.drawLine(rightShoulder, rightElbow, _paintLine);
      canvas.drawLine(rightElbow, rightWrist, _paintLine);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
