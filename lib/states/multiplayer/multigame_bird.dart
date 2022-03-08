// ignore_for_file: camel_case_types

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/bird_model.dart';
import 'package:project_game/model/g_game.dart';
import 'package:project_game/model/multimodel.dart';
import 'package:project_game/model/multiroom.dart';
import 'package:project_game/model/show_title.dart';
import 'package:project_game/utility/my_constant.dart';
import 'package:project_game/widgets/show_image.dart';
import 'package:project_game/widgets/show_progress.dart';

class Multi_GameBird extends StatefulWidget {
  const Multi_GameBird({Key? key}) : super(key: key);

  @override
  _Multi_GameBirdState createState() => _Multi_GameBirdState();
}

class _Multi_GameBirdState extends State<Multi_GameBird> {
  int timebird = 0, myAnswer = 0, score = 0, playTime = 0, timeStop = 0;
  List<int> idQuestions = [];
  List<BirdModel> birdModels = [];
  String? userUid;
  Qgame? q;
  MultiRoom? multiRoom;
  MultiModel? model;

  @override
  void initState() {
    super.initState();
    findUser();
    autoPlayTime();
    FlameAudio.bgm.play('sd0.mp3');
  }

  Future<void> findUser() async {
    // ignore: await_only_futures
    await FirebaseAuth.instance.authStateChanges().listen((event) {
      userUid = event!.uid;
      FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .collection('q_game')
          .doc('doc1')
          .get()
          .then((value) {
        q = Qgame.fromMap(value.data()!);
      }).then((value) {
        for (var i = 0; i < 10; i++) {
          FirebaseFirestore.instance
              .collection('rabbit')
              .doc('doc${q!.questions[i]}')
              .get()
              .then((value) {
            BirdModel model = BirdModel.fromMap(
              value.data()!,
            );
            setState(() {
              birdModels.add(model);
            });
          });
          print('## ${q!.questions[i]}');
        }
      }).then((value) {
        FirebaseFirestore.instance
            .collection('user')
            .doc(userUid)
            .collection('multiroom')
            .where('idClass', isNotEqualTo: 'A')
            .get()
            .then((value) {
          setState(() {
            multiRoom = MultiRoom.fromMap(value.docs[0].data());
          });
        });
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.p2,
        title: Text('Rabbit Counting Game'),
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
      floatingActionButton: buildFloating(),
      body: birdModels.isEmpty
          ? ShowProgress()
          : Center(
              child: Column(
                children: [
                  Container(
                    width: 350,
                    height: 350,
                    child: ShowImage(partUrl: birdModels[timebird].path),
                  ),
                  // buildImage(),
                  buildMyAnswer(),
                  Spacer(),
                  buttonAnswer(),
                ],
              ),
            ),
    );
  }

  Padding buttonAnswer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: IconButton(
        onPressed: () {
          FlameAudio.playLongAudio('add.mp3');
          setState(() {
            myAnswer++;
          });
        },
        icon: Icon(
          Icons.add_circle,
          size: 60,
        ),
      ),
    );
  }

  ShowTitle buildMyAnswer() =>
      ShowTitle(title: myAnswer.toString(), textStyle: MyConstant().h0Style());

  Future<void> processCalculate() async {
    FlameAudio.playLongAudio('bt2.mp3');
    if (timebird == 9) {
      FlameAudio.bgm.pause();
      if (myAnswer == birdModels[timebird].answer) {
        score++;
      }
      await FirebaseFirestore.instance
          .collection('multiplayer')
          .doc(q!.idClass)
          .get()
          .then((value) {
        setState(() {
          model = MultiModel.fromMap(value.data()!);
        });
      });

      if (userUid == model!.adminid) {
        await FirebaseFirestore.instance
            .collection('multiplayer')
            .doc(model!.idClass)
            .update({
          'scoreplayer1': score,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('multiplayer')
            .doc(model!.idClass)
            .update({
          'scoreplayer2': score,
        });
      }
      Navigator.pushNamedAndRemoveUntil(
          context, MyConstant.routeResultMultiGame, (route) => false);
    } else {
      if (myAnswer == birdModels[timebird].answer) {
        score++;
      }

      setState(() {
        myAnswer = 0;
        timebird++;
      });
    }
  }

  FloatingActionButton buildFloating() {
    return FloatingActionButton(
      onPressed: () => processCalculate(),
      child: Text(
        (timebird + 1).toString(),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
