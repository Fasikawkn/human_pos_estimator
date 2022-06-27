import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:human_pos_estimator/home_page.dart';


List<CameraDescription> cameras = [];
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++Error: $e.code\nError Message: $e.message');
  }
  runApp(const HumanPoseEstimator());
}


class HumanPoseEstimator extends StatelessWidget {
  const HumanPoseEstimator({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green
      ),
      home:  HomePage(
        cameras: cameras,
      ),
    );
  }
}

