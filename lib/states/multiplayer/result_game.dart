// ignore_for_file: unused_import, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/multimodel.dart';
import 'package:project_game/model/multiroom.dart';
import 'package:project_game/utility/my_constant.dart';
import 'package:project_game/widgets/show_progress.dart';

class ResultMultiGame extends StatefulWidget {
  ResultMultiGame({Key? key}) : super(key: key);

  @override
  State<ResultMultiGame> createState() => _ResultMultiGameState();
}

class _ResultMultiGameState extends State<ResultMultiGame> {
  String? uid, nameresult;
  MultiRoom? multiRoom;
  MultiModel? model;
  int result = 0;
  bool _running = true;

  Future findRoom() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('q_game')
          .doc('doc1')
          .get()
          .then((value) async {
        setState(() {
          multiRoom = MultiRoom.fromMap(value.data()!);
        });
        await FirebaseFirestore.instance
            .collection('multiplayer')
            .doc(multiRoom!.idClass)
            .get()
            .then((value) {
          setState(() {
            model = MultiModel.fromMap(value.data()!);
          });
        });
      });
    });
  }

  Future movePage() async {
    while (_running) {
      await Future<void>.delayed(const Duration(seconds: 1));
      findRoom();
      if (model != null) {
        if (model!.scoreplayer1 > model!.scoreplayer2) {
          setState(() {
            result = 1;
            nameresult = model!.nameplayer1;
          });
        } else if (model!.scoreplayer1 < model!.scoreplayer2) {
          setState(() {
            result = 2;
            nameresult = model!.nameplayer2;
          });
        } else if (model!.scoreplayer1 == model!.scoreplayer2) {
          setState(() {
            result = 3;
          });
        }
        if (model!.scoreplayer1 != -1 && model!.scoreplayer2 != -1) {
          FlameAudio.playLongAudio('fn1.mp3');
          _running = false;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    movePage();
  }

  Widget build(BuildContext context) {
    if (model != null) {
      if (model!.scoreplayer1 > model!.scoreplayer2) {
        setState(() {
          result = 1;
          nameresult = model!.nameplayer1;
        });
      } else if (model!.scoreplayer1 < model!.scoreplayer2) {
        setState(() {
          result = 2;
          nameresult = model!.nameplayer2;
        });
      } else if (model!.scoreplayer1 == model!.scoreplayer2) {
        setState(() {
          result = 3;
        });
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('สรุปผล'),
        ),
        body: model != null &&
                model!.scoreplayer1 != -1 &&
                model!.scoreplayer2 != -1
            ? result == 3
                ? Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 350,
                            width: 350,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.blue[400]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Image.asset('asset/images/tie.gif')],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 350,
                                height: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.blue[200]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "ทั้งคู่เสมอกัน",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection('multiplayer')
                                      .doc(multiRoom!.idClass)
                                      .delete();
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      MyConstant.routePagemenu,
                                      (route) => false);
                                },
                                child: Container(
                                  height: 50.0,
                                  width: 350,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "กลับหน้าหลัก",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 350,
                            width: 350,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.blue[400]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('asset/images/winner.gif')
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 350,
                                height: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.blue[200]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "ผู้เล่น $result: $nameresult",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection('multiplayer')
                                      .doc(multiRoom!.idClass)
                                      .delete();
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      MyConstant.routeMainPage,
                                      (route) => false);
                                },
                                child: Container(
                                  height: 50.0,
                                  width: 350,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "กลับหน้าหลัก",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
            : Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                              child: Stack(
                            children: <Widget>[
                              // Stroked text as border.
                              Text(
                                'กรุณารอผู้เล่นฝ่ายตรงข้าม',
                                style: TextStyle(
                                  fontSize: 30,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 6
                                    ..color = Colors.indigo[900]!,
                                ),
                              ),
                              // Solid text as fill.
                              Text(
                                'กรุณารอผู้เล่นฝ่ายตรงข้าม',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
  }
}
