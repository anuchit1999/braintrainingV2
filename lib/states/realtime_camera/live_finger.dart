import 'dart:async';
import 'dart:math';

import 'package:animated_button/animated_button.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/bird_model.dart';
import 'package:project_game/model/score_model.dart';
import 'package:project_game/states/realtime_camera/bounding_box.dart';
import 'package:project_game/states/realtime_camera/camera.dart';
import 'package:project_game/utility/my_constant.dart';
import 'dart:math' as math;
import 'package:tflite/tflite.dart';
import 'package:vibration/vibration.dart';

class LiveFeedFingermaths extends StatefulWidget {
  final List<CameraDescription> cameras;
  LiveFeedFingermaths(this.cameras);
  @override
  _LiveFeedFingermathsState createState() => _LiveFeedFingermathsState();
}

class _LiveFeedFingermathsState extends State<LiveFeedFingermaths> {
  List<dynamic>? _recognitions;
  int timeFinger = 0, playTime = 0, myAnswer = 0, score = 0;
  int _imageHeight = 0;
  int _imageWidth = 0;
  int? i;
  int nonStack = -1;
  List<int> idQuestions = [];
  List<BirdModel> fingerModels = [];
  late String userUid;
  String checkList = '';
  initCameras() async {}
  loadTfModel() async {
    await Tflite.loadModel(
      model: "asset/models/ssd_mobilenet.tflite",
      labels: "asset/models/labels.txt",
    );
  }

  Future<void> autoPlayTime() async {
    Duration duration = Duration(seconds: 1);
    // ignore: await_only_futures
    await Timer(duration, () {
      setState(() {
        playTime++;
      });
      if (playTime % 2 == 0) {
        checkList = '';
      }
      autoPlayTime();
    });
  }

  Future<void> randomQuestion() async {
    for (var j = 0; j < 10; j++) {
      do {
        i = Random().nextInt(11);
      } while (i == nonStack);
      nonStack = i!;
      idQuestions.add(i!);

      await FirebaseFirestore.instance
          .collection('finger')
          .doc('doc$i')
          .get()
          .then((value) {
        BirdModel model = BirdModel.fromMap(
          value.data()!,
        );
        setState(() {
          fingerModels.add(model);
        });
      });
    }
    print('## $idQuestions');
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
    super.initState();
    randomQuestion();
    autoPlayTime();
    loadTfModel();
    findUser();
    randomMusic();
  }

  Future<void> randomMusic() async {
    int sound = Random().nextInt(4);
    FlameAudio.bgm.play('sd$sound.mp3');
  }

  Future<void> findUser() async {
    // ignore: await_only_futures
    await FirebaseAuth.instance.authStateChanges().listen((event) {
      userUid = event!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    var detec;
    try {
      setState(() {
        detec = _recognitions![0]["detectedClass"];
      });
    } catch (e) {}
    if (detec == "One") {
      setState(() {
        myAnswer = 1;
      });
    } else if (detec == "Two") {
      setState(() {
        myAnswer = 2;
      });
    } else if (detec == "Three") {
      setState(() {
        myAnswer = 3;
      });
    } else if (detec == "Four") {
      setState(() {
        myAnswer = 4;
      });
    } else if (detec == "Five") {
      setState(() {
        myAnswer = 5;
      });
    } else if (detec == "Zero") {
      setState(() {
        myAnswer = 0;
      });
    } else {
      setState(() {
        myAnswer = -1;
      });
    }
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(child: CameraFeed(widget.cameras, setRecognitions)),
                Container(
                  child: BoundingBox(
                    _recognitions == null ? [] : _recognitions!,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            fingerModels.isEmpty
                                ? Text("กรุณารอสักครู่...")
                                : Stack(
                                    children: <Widget>[
                                      // Stroked text as border.
                                      Text(
                                        '${fingerModels[timeFinger].path} = ${myAnswer == -1 ? '?' : '$myAnswer'}',
                                        style: TextStyle(
                                          fontSize: 68,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 6
                                            ..color = Colors.indigo[900]!,
                                        ),
                                      ),
                                      // Solid text as fill.
                                      Text(
                                        '${fingerModels[timeFinger].path} = ${myAnswer == -1 ? '?' : '$myAnswer'}',
                                        style: TextStyle(
                                          fontSize: 68,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 48,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Stack(
                              children: <Widget>[
                                // Stroked text as border.
                                Text(
                                  '$score',
                                  style: TextStyle(
                                    fontSize: 35,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 6
                                      ..color = Colors.indigo[900]!,
                                  ),
                                ),
                                // Solid text as fill.
                                Text(
                                  '$score',
                                  style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            playTime > 59
                                ? Stack(
                                    children: <Widget>[
                                      // Stroked text as border.
                                      Text(
                                        '${playTime ~/ 60} นาที ${playTime % 60} วินาที',
                                        style: TextStyle(
                                          fontSize: 15,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 6
                                            ..color = Colors.indigo[900]!,
                                        ),
                                      ),
                                      // Solid text as fill.
                                      Text(
                                        '${playTime ~/ 60} นาที ${playTime % 60} วินาที',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                : Stack(
                                    children: <Widget>[
                                      // Stroked text as border.
                                      Text(
                                        '$playTime วินาที',
                                        style: TextStyle(
                                          fontSize: 15,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 6
                                            ..color = Colors.indigo[900]!,
                                        ),
                                      ),
                                      // Solid text as fill.
                                      Text(
                                        '$playTime วินาที',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                checkList == 'T'
                    ? Center(
                        child: Container(
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 200,
                          ),
                        ),
                      )
                    : checkList == 'F'
                        ? Center(
                            child: Container(
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 200,
                              ),
                            ),
                          )
                        : Container(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedButton(
                              height: 60,
                              width: 350,
                              child: Text(
                                'ข้อที่ ${timeFinger + 1}',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              color: MyConstant.p1,
                              onPressed: () {
                                processCalculate();
                              },
                              enabled: true,
                              shadowDegree: ShadowDegree.light,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> processCalculate() async {
    FlameAudio.playLongAudio('bt2.mp3');
    if (timeFinger == 9) {
      FlameAudio.bgm.pause();
      if (myAnswer == fingerModels[timeFinger].answer) {
        setState(() {
          score++;
          checkList = 'T';
        });
      } else {
        checkList = 'F';
        Vibration.vibrate();
      }
      print('## $score');

      DateTime dateTime = DateTime.now();
      Timestamp playDate = Timestamp.fromDate(dateTime);

      ScoreModel model = ScoreModel(score, playTime, playDate);

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .collection('scorefingermath')
          .doc(
              '${dateTime.year}${dateTime.month < 10 ? '0' : ''}${dateTime.month}${dateTime.day < 10 ? '0' : ''}${dateTime.day}${dateTime.hour < 10 ? '0' : ''}${dateTime.hour}${dateTime.minute < 10 ? '0' : ''}${dateTime.minute}')
          .set(model.toMap())
          .then((value) => Navigator.pushNamedAndRemoveUntil(
              context, MyConstant.routeResultFingermaths, (route) => false));
    } else {
      if (myAnswer == fingerModels[timeFinger].answer) {
        setState(() {
          score++;
          checkList = 'T';
          myAnswer = -1;
        });
      } else {
        checkList = 'F';
        Vibration.vibrate();
        myAnswer = -1;
      }
      print('## $score');
      setState(() {
        myAnswer = 0;
        timeFinger++;
      });
    }
  }
}
