import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:human_pos_estimator/pose_estimator.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.cameras,  Key? key }) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pose Estmation',
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              const Text(
                'Realtime Pose Estimator',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: const DecorationImage(
                      image: AssetImage('assets/cricket.png'),
                      fit: BoxFit.fill,
                    )),
              ),
              const SizedBox(
                height: 50.0,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('Estimate Your Position'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PoseEstimator(cameras),
                    ));
                  },
                ),
              ),
            ],
          ),
        ));
  }
}