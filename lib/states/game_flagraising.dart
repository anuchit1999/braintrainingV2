// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/bird_model.dart';
import 'package:project_game/model/score_model.dart';
import 'package:project_game/model/show_title.dart';
import 'package:project_game/utility/my_constant.dart';
import 'package:project_game/widgets/show_image.dart';
import 'package:project_game/widgets/show_progress.dart';
import 'package:sensors/sensors.dart';
import 'package:vibration/vibration.dart';

class GameFlagraising extends StatefulWidget {
  const GameFlagraising({Key? key}) : super(key: key);

  @override
  _GameFlagraisingState createState() => _GameFlagraisingState();
}

class _GameFlagraisingState extends State<GameFlagraising> {
  int timeFlag = 0,
      myAnswer = 0,
      score = 0,
      playTime = 0,
      timeStop = 0,
      supFlag = 0,
      nonStack = -1,
      testShowsub = 0,
      preQuestion = 0;
  int? i;
  double x = 0, y = 0, z = 0;
  List<int> idQuestions = [];
  List<BirdModel> flagModels = [];
  late String userUid;
  String nameAnswer = '', preQuestionT = '';
  bool _running = false, _runningPage = true;

  @override
  void initState() {
    super.initState();
    randomQuestion();
    autoPlayTime();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    });
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

  Future<void> autoPlayTime() async {
    Duration duration = Duration(seconds: 1);
    // ignore: await_only_futures
    await Timer(duration, () {
      setState(() {
        playTime++;
      });
      autoPlayTime();
    });
  }

  Future<void> randomQuestion() async {
    for (var j = 0; j < 5; j++) {
      do {
        i = Random().nextInt(3);
      } while (i == nonStack);
      nonStack = i!;
      idQuestions.add(i!);

      await FirebaseFirestore.instance
          .collection('flag')
          .doc('doc$i')
          .get()
          .then((value) {
        BirdModel model = BirdModel.fromMap(
          value.data()!,
        );
        setState(() {
          flagModels.add(model);
        });
      });
    }
    print('## $idQuestions');
    pageShow();
  }

  Future pageShow() async {
    while (_runningPage) {
      await Future<void>.delayed(const Duration(seconds: 2));
      setState(() {
        if (preQuestion == 0) {
          preQuestionT = 'จำทิศทางต่อไปนี้';
          preQuestion++;
        } else {
          if (testShowsub == timeFlag + 1) {
            preQuestion++;
          } else {
            testShowsub++;
          }
        }
      });
      if (preQuestion == 2) {
        setState(() {
          testShowsub = 0;
          preQuestion = 0;
          myAnswer = 0;
          nameAnswer = '';
          _runningPage = false;
          _running = true;
          ansWer();
        });
      }
    }
  }

  Future ansWer() async {
    while (_running) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (x >= -2 && x <= 2 && y >= 8 && y <= 10 && z >= -2 && z <= 2) {
        setState(() {
          myAnswer = 1;
          nameAnswer = 'UP';
        });
      } else if (x >= 8 && x <= 10 && y >= -2 && y <= 2 && z >= -2 && z <= 2) {
        setState(() {
          myAnswer = 2;
          nameAnswer = 'LEFT';
        });
      } else if (x <= -8 &&
          x >= -10 &&
          y >= -2 &&
          y <= 2 &&
          z >= -2 &&
          z <= 2) {
        setState(() {
          myAnswer = 3;
          nameAnswer = 'RIGHT';
        });
      }
      if (timeFlag == 4 && supFlag == 4) {
        FlameAudio.bgm.pause();
        if (myAnswer == flagModels[supFlag].answer) {
          score++;
          _running = false;
          timeStop = playTime;

          DateTime dateTime = DateTime.now();
          Timestamp playDate = Timestamp.fromDate(dateTime);

          ScoreModel model = ScoreModel(score, playTime, playDate);

          await FirebaseFirestore.instance
              .collection('user')
              .doc(userUid)
              .collection('scoreflag')
              .doc(
                  '${dateTime.year}${dateTime.month < 10 ? '0' : ''}${dateTime.month}${dateTime.day < 10 ? '0' : ''}${dateTime.day}${dateTime.hour < 10 ? '0' : ''}${dateTime.hour}${dateTime.minute < 10 ? '0' : ''}${dateTime.minute}')
              .set(model.toMap())
              .then((value) => Navigator.pushNamedAndRemoveUntil(context,
                  MyConstant.routeResultFlagraising, (route) => false));
        }
      } else {
        if (myAnswer == flagModels[supFlag].answer) {
          score++;
          if (supFlag == timeFlag) {
            Vibration.vibrate();
            setState(() {
              timeFlag++;
              supFlag = 0;
              _running = false;
              _runningPage = true;
              pageShow();
            });
          } else {
            setState(() {
              supFlag++;
              Vibration.vibrate();
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flagraising Game'),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: playTime > 59
                    ? Text('${playTime ~/ 60} นาที ${playTime % 60} วินาที')
                    : Text('$playTime วินาที'),
              ),
            ],
          )
        ],
      ),
      body: flagModels.isEmpty
          ? ShowProgress()
          : _runningPage
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      preQuestion == 0
                          ? ShowTitle(
                              title: "จดจำทิศทาง",
                              textStyle: MyConstant().h5Style())
                          : testShowsub == timeFlag + 1
                              ? ShowTitle(
                                  title: "ตอบทิศทาง",
                                  textStyle: MyConstant().h5Style())
                              : buildImage(),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildMyAnswer(),
                    ],
                  ),
                ),
    );
  }

  ShowTitle buildMyAnswer() =>
      ShowTitle(title: "$nameAnswer", textStyle: MyConstant().h5Style());

  Container buildImage() {
    return Container(
      width: 350,
      height: 350,
      child: ShowImage(partUrl: flagModels[testShowsub].path),
    );
  }
}
