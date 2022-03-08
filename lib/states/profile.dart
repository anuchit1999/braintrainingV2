// ignore_for_file: unused_field, must_call_super, await_only_futures, unused_import

import 'package:animated_button/animated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/user_model.dart';
import 'package:project_game/utility/my_constant.dart';
import 'package:project_game/widgets/show_navigator.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserModel? userModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    findProfile();
  }

  Future findProfile() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      String uid = event!.uid;
      print('## uid = $uid');
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .get()
          .then((value) {
        setState(() {
          userModel = UserModel.fromMap(value.data()!);
        });
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
      body: userModel == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("asset/images/bg_profile.jpg"),
                    fit: BoxFit.cover),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 40,
                                  offset: Offset(8, 10),
                                  color: MyConstant.p1.withOpacity(0.7),
                                ),
                                BoxShadow(
                                  blurRadius: 10,
                                  offset: Offset(-1, -5),
                                  color: MyConstant.p1.withOpacity(0.7),
                                )
                              ]),
                          padding: const EdgeInsets.only(
                              top: 30, left: 30, right: 30, bottom: 30),
                          child: Column(
                            children: [
                              buildImage(),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 10),
                                  Text(
                                    "ชื่อผู้ใช้",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  // Expanded(child: Container(
                                  // )),
                                  Container(
                                    width: 150,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: MyConstant.p4,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${userModel!.name}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 10),
                                  Text(
                                    "อายุ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 45,
                                  ),
                                  // Expanded(child: Container(
                                  // )),
                                  Container(
                                    width: 80,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: MyConstant.p4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${userModel!.age.toStringAsFixed(0)}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        (MediaQuery.of(context).size.height /
                                                4) /
                                            2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    (MediaQuery.of(context).size.height / 4) /
                                        2,
                              ),
                              AnimatedButton(
                                child: Text(
                                  'แก้ไขข้อมูลส่วนตัว',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                color: MyConstant.p4,
                                onPressed: () {
                                  FlameAudio.playLongAudio('bt1.mp3');
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      MyConstant.routeEditProfile,
                                      (route) => false);
                                },
                                enabled: true,
                                shadowDegree: ShadowDegree.light,
                                duration: 400,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Container buildImage() {
    return Container(
      child: CircleAvatar(
        minRadius: 0,
        maxRadius: 70,
        backgroundColor: MyConstant.p4,
        child: CircleAvatar(
          radius: 90,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: Image.network(
              "${userModel!.urlProfile}",
              width: 130,
              height: 130,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
