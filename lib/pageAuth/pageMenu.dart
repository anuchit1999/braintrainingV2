import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
// ignore: unused_import
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/profile.dart';
import 'package:project_game/model/show_title.dart';
import 'package:project_game/model/user_model.dart';
import 'package:project_game/utility/my_constant.dart';
import 'package:project_game/widgets/show_navigator.dart';
import 'package:project_game/widgets/show_progress.dart';

class PageMenu extends StatefulWidget {
  @override
  _PageMenuState createState() => _PageMenuState();
}

class _PageMenuState extends State<PageMenu> {
  UserModel? userModel;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    findProfile();
    FlameAudio.bgm.pause();
    FlameAudio.bgm.play('bg_2.mp3');
  }

  Future<void> findProfile() async {
    // ignore: await_only_futures
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      String uid = event!.uid;
      print('## uid = $uid');
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .get()
          .then((value) async {
        if (!mounted) return;
        setState(() {
          try {
            userModel = UserModel.fromMap(value.data()!);
            // ignore: unused_catch_clause
          } on Exception catch (e) {}
        });
      });
    });
  }

  final auth = FirebaseAuth.instance;
  Profile profile =
      Profile(email: '', password: '', age: '', name: '', urlProfile: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      body: userModel == null
          ? ShowProgress()
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 0),
                            height: 300,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                ),
                                image: DecorationImage(
                                    image: AssetImage("asset/images/prob.png"),
                                    fit: BoxFit.fill),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 40,
                                    offset: Offset(8, 10),
                                    color: MyConstant.p1.withOpacity(1),
                                  ),
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: Offset(-1, -5),
                                    color: MyConstant.p1.withOpacity(1),
                                  )
                                ]),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 15, top: 35),
                            child: CircleAvatar(
                              radius: 90,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: Image.network(
                                  userModel!.urlProfile,
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            height: 100,
                            // color: Colors.black.withOpacity(0.3),
                            margin: const EdgeInsets.only(left: 170, top: 90),
                            child: Column(
                              children: [
                                buildName(),
                                SizedBox(height: 2),
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 3),
                                      minimumSize: Size(20, 30),
                                      primary: MyConstant.p1,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 2,
                                      shadowColor: Colors.black,
                                    ),
                                    icon: Icon(Icons.logout_sharp, size: 20),
                                    label: Text(
                                      "ออกจากระบบ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      auth.signOut().then((value) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            MyConstant.routeHome,
                                            (route) => false);
                                      });
                                      FlameAudio.playLongAudio('bt_m.mp3');
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: ShowNavigator(
                        iconData: Icons.filter_1,
                        label: 'Rabbit Counting',
                        routeState: MyConstant.routeIntroBird,
                        color: MyConstant.p1,
                        colorFont: Colors.white,
                      ),
                    ),
                    Container(
                      child: ShowNavigator(
                        iconData: Icons.filter_2,
                        label: 'Box Counting',
                        routeState: MyConstant.routeIntroBox,
                        color: MyConstant.p1,
                        colorFont: Colors.white,
                      ),
                    ),
                    Container(
                      child: ShowNavigator(
                        iconData: Icons.filter_3,
                        label: 'Flag Raising',
                        routeState: MyConstant.routeIntroFlagraising,
                        color: MyConstant.p1,
                        colorFont: Colors.white,
                      ),
                    ),
                    Container(
                      child: ShowNavigator(
                        iconData: Icons.filter_4,
                        label: 'Finger Math',
                        routeState: MyConstant.routeIntroFingermath,
                        color: MyConstant.p1,
                        colorFont: Colors.white,
                      ),
                    ),
                    Container(
                      child: ShowNavigator(
                        iconData: Icons.filter_5,
                        label: 'Rock Paper Scissors',
                        routeState: MyConstant.routeIntroRock,
                        color: MyConstant.p1,
                        colorFont: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  ShowTitle buildName() {
    return ShowTitle(
      title: userModel!.name,
      textStyle: MyConstant().h4Style(),
    );
  }
}
