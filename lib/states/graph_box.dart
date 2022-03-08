// ignore_for_file: await_only_futures

import 'package:animated_button/animated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_game/model/score_model.dart';
import 'package:project_game/utility/my_constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphBox extends StatefulWidget {
  GraphBox({Key? key}) : super(key: key);

  @override
  State<GraphBox> createState() => _GraphBoxState();
}

class _GraphBoxState extends State<GraphBox> {
  String? uid;
  int sumSunD = 0,
      sumMonD = 0,
      sumTueD = 0,
      sumWedD = 0,
      sumThuD = 0,
      sumFriD = 0,
      sumSatD = 0;
  int sumSunW = 0,
      sumMonW = 0,
      sumTueW = 0,
      sumWedW = 0,
      sumThuW = 0,
      sumFriW = 0,
      sumSatW = 0;
  int m1 = 0,
      m2 = 0,
      m3 = 0,
      m4 = 0,
      m5 = 0,
      m6 = 0,
      m7 = 0,
      m8 = 0,
      m9 = 0,
      m10 = 0,
      m11 = 0,
      m12 = 0;
  int sumSunDT = 0,
      sumMonDT = 0,
      sumTueDT = 0,
      sumWedDT = 0,
      sumThuDT = 0,
      sumFriDT = 0,
      sumSatDT = 0;
  int sumSunWT = 0,
      sumMonWT = 0,
      sumTueWT = 0,
      sumWedWT = 0,
      sumThuWT = 0,
      sumFriWT = 0,
      sumSatWT = 0;
  int m1T = 0,
      m2T = 0,
      m3T = 0,
      m4T = 0,
      m5T = 0,
      m6T = 0,
      m7T = 0,
      m8T = 0,
      m9T = 0,
      m10T = 0,
      m11T = 0,
      m12T = 0;
  int msec = 86400000;
  int monthC = 0, monthCC = 0;
  int weekStart = 0; // monthStart = 0, monthStartCount = 0;
  int weekCount = 0, dayCount = 0, monthCount = 0;
  List<String> selDay = [], selWeek = [], selMonth = [];
  List<Map<String, int>> setscoreDay = [];
  String? dateDay, dateWeek, dateMonth;
  String dateT = '';
  String toDay = '', toMonth = '', toMonthCount = '', fMonth = '';
  String dateYearD = '', dateYearW = '', dateYearM = '', dateYearWT = '';
  String dateNow = DateFormat('d MMM y').format(
      DateTime.fromMillisecondsSinceEpoch(
          Timestamp.fromDate(DateTime.now()).toDate().millisecondsSinceEpoch));
  String weekNow = DateFormat('EEEE d MMM y').format(
      DateTime.fromMillisecondsSinceEpoch(
          Timestamp.fromDate(DateTime.now()).toDate().millisecondsSinceEpoch));

  Future selectDay() async {
    setState(() {
      selDay = [];
    });
    for (int i = 6; i >= 0; i--) {
      selDay.add(DateFormat('d MMM y').format(
          DateTime.fromMillisecondsSinceEpoch(Timestamp.fromDate(DateTime.now())
                  .toDate()
                  .millisecondsSinceEpoch -
              ((msec * dayCount) + (msec * i)))));
      dateYearD = DateFormat('MMM y').format(
          DateTime.fromMillisecondsSinceEpoch(Timestamp.fromDate(DateTime.now())
                  .toDate()
                  .millisecondsSinceEpoch -
              ((msec * dayCount) + (msec * i))));
    }
  }

  Future selectWeek() async {
    setState(() {
      selWeek = [];
    });
    toDay = DateFormat('EEE').format(DateTime.fromMillisecondsSinceEpoch(
        Timestamp.fromDate(DateTime.now()).toDate().millisecondsSinceEpoch));
    if (toDay == 'Mon') {
      weekStart = msec * 5;
    } else if (toDay == 'Tue') {
      weekStart = msec * 4;
    } else if (toDay == 'Wed') {
      weekStart = msec * 3;
    } else if (toDay == 'Thu') {
      weekStart = msec * 2;
    } else if (toDay == 'Fri') {
      weekStart = msec * 1;
    } else if (toDay == 'Sun') {
      weekStart = msec * 6;
    }
    for (int i = 6; i >= 0; i--) {
      selWeek.add(DateFormat('EEEE d MMM y').format(
          DateTime.fromMillisecondsSinceEpoch(Timestamp.fromDate(DateTime.now())
                  .toDate()
                  .millisecondsSinceEpoch -
              ((msec * weekCount) + (msec * i) - (weekStart)))));
      dateYearW = DateFormat('d MMM y').format(
          DateTime.fromMillisecondsSinceEpoch(Timestamp.fromDate(DateTime.now())
                  .toDate()
                  .millisecondsSinceEpoch -
              ((msec * weekCount) + (msec * i) - (weekStart))));
    }
    dateYearWT = DateFormat('d MMM y').format(
        DateTime.fromMillisecondsSinceEpoch(
            Timestamp.fromDate(DateTime.now()).toDate().millisecondsSinceEpoch -
                ((msec * weekCount) - (weekStart) + (msec * 6))));
  }

  Future selectMonth() async {
    setState(() {
      selMonth = [];
    });

    do {
      fMonth = DateFormat('M').format(DateTime.fromMillisecondsSinceEpoch(
          Timestamp.fromDate(DateTime.now()).toDate().millisecondsSinceEpoch -
              (msec * monthC) +
              (monthCount * msec)));
      monthC++;
    } while (fMonth != '1');
    selMonth.add(DateFormat('MMM y').format(DateTime.fromMillisecondsSinceEpoch(
        Timestamp.fromDate(DateTime.now()).toDate().millisecondsSinceEpoch -
            (msec * monthC) +
            (monthCount * msec))));

    for (int i = 10; i >= 0; i--) {
      do {
        toMonth = DateFormat('M').format(DateTime.fromMillisecondsSinceEpoch(
            Timestamp.fromDate(DateTime.now()).toDate().millisecondsSinceEpoch -
                (msec * monthC) +
                (msec * monthCC) +
                (monthCount * msec)));
        monthCC++;
      } while (toMonth == fMonth);
      selMonth.add(DateFormat('MMM y').format(
          DateTime.fromMillisecondsSinceEpoch(Timestamp.fromDate(DateTime.now())
                  .toDate()
                  .millisecondsSinceEpoch -
              (msec * monthC) +
              (msec * monthCC) +
              (monthCount * msec))));
      fMonth = DateFormat('M').format(DateTime.fromMillisecondsSinceEpoch(
          Timestamp.fromDate(DateTime.now()).toDate().millisecondsSinceEpoch -
              (msec * monthC) +
              (msec * monthCC) +
              (monthCount * msec)));

      dateYearM = DateFormat('y').format(DateTime.fromMillisecondsSinceEpoch(
          Timestamp.fromDate(DateTime.now()).toDate().millisecondsSinceEpoch -
              (msec * monthC) +
              (msec * monthCC) +
              (monthCount * msec)));
    }
  }

  Future graphListDay() async {
    sumSunD = 0;
    sumMonD = 0;
    sumTueD = 0;
    sumWedD = 0;
    sumThuD = 0;
    sumFriD = 0;
    sumSatD = 0;
    sumSunDT = 0;
    sumMonDT = 0;
    sumTueDT = 0;
    sumWedDT = 0;
    sumThuDT = 0;
    sumFriDT = 0;
    sumSatDT = 0;
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('scorebox')
          .get()
          .then((value) {
        for (var item in value.docs) {
          ScoreModel model = ScoreModel.fromMap(item.data());
          setState(() {
            Timestamp time = model.playDate;
            var date = new DateTime.fromMicrosecondsSinceEpoch(
                time.microsecondsSinceEpoch);
            dateDay = new DateFormat('d MMM y').format(date);
            if (dateDay == selDay[0]) {
              sumSunD += model.score;
              sumSunDT++;
            } else if (dateDay == selDay[1]) {
              sumMonD += model.score;
              sumMonDT++;
            } else if (dateDay == selDay[2]) {
              sumTueD += model.score;
              sumTueDT++;
            } else if (dateDay == selDay[3]) {
              sumWedD += model.score;
              sumWedDT++;
            } else if (dateDay == selDay[4]) {
              sumThuD += model.score;
              sumThuDT++;
            } else if (dateDay == selDay[5]) {
              sumFriD += model.score;
              sumFriDT++;
            } else if (dateDay == selDay[6]) {
              sumSatD += model.score;
              sumSatDT++;
            }
          });
        }
        sumSunDT == 0 ? sumSunD = 0 : sumSunD ~/= sumSunDT;
        sumMonDT == 0 ? sumMonD = 0 : sumMonD ~/= sumMonDT;
        sumTueDT == 0 ? sumTueD = 0 : sumTueD ~/= sumTueDT;
        sumWedDT == 0 ? sumWedD = 0 : sumWedD ~/= sumWedDT;
        sumThuDT == 0 ? sumThuD = 0 : sumThuD ~/= sumThuDT;
        sumFriDT == 0 ? sumFriD = 0 : sumFriD ~/= sumFriDT;
        sumSatDT == 0 ? sumSatD = 0 : sumSatD ~/= sumSatDT;
      });
    });
  }

  Future graphListWeek() async {
    sumSunW = 0;
    sumMonW = 0;
    sumTueW = 0;
    sumWedW = 0;
    sumThuW = 0;
    sumFriW = 0;
    sumSatW = 0;
    sumSunWT = 0;
    sumMonWT = 0;
    sumTueWT = 0;
    sumWedWT = 0;
    sumThuWT = 0;
    sumFriWT = 0;
    sumSatWT = 0;
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('scorebox')
          .get()
          .then((value) {
        for (var item in value.docs) {
          ScoreModel model = ScoreModel.fromMap(item.data());
          setState(() {
            Timestamp time = model.playDate;
            var date = new DateTime.fromMicrosecondsSinceEpoch(
                time.microsecondsSinceEpoch);
            dateWeek = new DateFormat('EEEE d MMM y').format(date);
            if (dateWeek == selWeek[0]) {
              sumSunW += model.score;
              sumSunWT++;
            } else if (dateWeek == selWeek[1]) {
              sumMonW += model.score;
              sumMonWT++;
            } else if (dateWeek == selWeek[2]) {
              sumTueW += model.score;
              sumTueWT++;
            } else if (dateWeek == selWeek[3]) {
              sumWedW += model.score;
              sumWedWT++;
            } else if (dateWeek == selWeek[4]) {
              sumThuW += model.score;
              sumThuWT++;
            } else if (dateWeek == selWeek[5]) {
              sumFriW += model.score;
              sumFriWT++;
            } else if (dateWeek == selWeek[6]) {
              sumSatW += model.score;
              sumSatWT++;
            }
          });
        }
        sumSunWT == 0 ? sumSunW = 0 : sumSunW ~/= sumSunWT;
        sumMonWT == 0 ? sumMonW = 0 : sumMonW ~/= sumMonWT;
        sumTueWT == 0 ? sumTueW = 0 : sumTueW ~/= sumTueWT;
        sumWedWT == 0 ? sumWedW = 0 : sumWedW ~/= sumWedWT;
        sumThuWT == 0 ? sumThuW = 0 : sumThuW ~/= sumThuWT;
        sumFriWT == 0 ? sumFriW = 0 : sumFriW ~/= sumFriWT;
        sumSatWT == 0 ? sumSatW = 0 : sumSatW ~/= sumSatWT;
      });
    });
  }

  Future graphListMonth() async {
    m1 = 0;
    m2 = 0;
    m3 = 0;
    m4 = 0;
    m5 = 0;
    m6 = 0;
    m7 = 0;
    m8 = 0;
    m9 = 0;
    m10 = 0;
    m11 = 0;
    m12 = 0;
    m1T = 0;
    m2T = 0;
    m3T = 0;
    m4T = 0;
    m5T = 0;
    m6T = 0;
    m7T = 0;
    m8T = 0;
    m9T = 0;
    m10T = 0;
    m11T = 0;
    m12T = 0;
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('scorebox')
          .get()
          .then((value) {
        for (var item in value.docs) {
          ScoreModel model = ScoreModel.fromMap(item.data());
          setState(() {
            Timestamp time = model.playDate;
            var date = new DateTime.fromMicrosecondsSinceEpoch(
                time.microsecondsSinceEpoch);
            dateMonth = new DateFormat('MMM y').format(date);
            if (dateMonth == selMonth[0]) {
              m1 += model.score;
              m1T++;
            } else if (dateMonth == selMonth[1]) {
              m2 += model.score;
              m2T++;
            } else if (dateMonth == selMonth[2]) {
              m3 += model.score;
              m3T++;
            } else if (dateMonth == selMonth[3]) {
              m4 += model.score;
              m4T++;
            } else if (dateMonth == selMonth[4]) {
              m5 += model.score;
              m5T++;
            } else if (dateMonth == selMonth[5]) {
              m6 += model.score;
              m6T++;
            } else if (dateMonth == selMonth[6]) {
              m7 += model.score;
              m7T++;
            } else if (dateMonth == selMonth[7]) {
              m8 += model.score;
              m8T++;
            } else if (dateMonth == selMonth[8]) {
              m9 += model.score;
              m9T++;
            } else if (dateMonth == selMonth[9]) {
              m10 += model.score;
              m10T++;
            } else if (dateMonth == selMonth[10]) {
              m11 += model.score;
              m11T++;
            } else if (dateMonth == selMonth[11]) {
              m12 += model.score;
              m12T++;
            }
          });
        }
        m1T == 0 ? m1 = 0 : m1 ~/= m1T;
        m2T == 0 ? m2 = 0 : m2 ~/= m2T;
        m3T == 0 ? m3 = 0 : m3 ~/= m3T;
        m4T == 0 ? m4 = 0 : m4 ~/= m4T;
        m5T == 0 ? m5 = 0 : m5 ~/= m5T;
        m6T == 0 ? m6 = 0 : m6 ~/= m6T;
        m7T == 0 ? m7 = 0 : m7 ~/= m7T;
        m8T == 0 ? m8 = 0 : m8 ~/= m8T;
        m9T == 0 ? m9 = 0 : m9 ~/= m9T;
        m10T == 0 ? m10 = 0 : m10 ~/= m10T;
        m11T == 0 ? m11 = 0 : m11 ~/= m11T;
        m12T == 0 ? m12 = 0 : m12 ~/= m12T;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    selectDay();
    graphListDay();
    selectWeek();
    graphListWeek();
    selectMonth();
    graphListMonth();
  }

  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[200],
            foregroundColor: Colors.black,
            title: Text("Graph Box Counting"),
            bottom: TabBar(
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.blue.shade50,
                      Colors.blue,
                      Colors.blue.shade900
                    ]),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueAccent[400]),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("GraphDay"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("GraphWeek"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("GraphMonth"),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(
            children: [
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/images/bg.png'),
                          fit: BoxFit.cover)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedButton(
                              height: 40,
                              width: 60,
                              child: Text(
                                '<-',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              color: MyConstant.p3,
                              onPressed: () {
                                FlameAudio.playLongAudio('bt2.mp3');
                                setState(() {
                                  dayCount += 1;
                                });
                                selectDay();
                                graphListDay();
                              },
                              enabled: true,
                              shadowDegree: ShadowDegree.light,
                              duration: 400,
                            ),
                            SizedBox(
                              width: 60,
                            ),
                            AnimatedButton(
                              height: 40,
                              width: 60,
                              child: Text(
                                '->',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              color: MyConstant.p3,
                              onPressed: () {
                                FlameAudio.playLongAudio('bt2.mp3');
                                setState(() {
                                  dayCount -= 1;
                                });
                                selectDay();
                                graphListDay();
                              },
                              enabled: true,
                              shadowDegree: ShadowDegree.light,
                              duration: 400,
                            ),
                          ],
                        ),
                        SfCartesianChart(
                          title: ChartTitle(text: '$dateYearD'),
                          legend: Legend(isVisible: false),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries>[
                            ColumnSeries<MildDateD, String>(
                                dataSource: [
                                  MildDateD(
                                      selDay[0].substring(0, 2),
                                      sumSunD,
                                      dateNow == selDay[0]
                                          ? Colors.teal
                                          : MyConstant.p3),
                                  MildDateD(
                                      selDay[1].substring(0, 2),
                                      sumMonD,
                                      dateNow == selDay[1]
                                          ? Colors.teal
                                          : MyConstant.p3),
                                  MildDateD(
                                      selDay[2].substring(0, 2),
                                      sumTueD,
                                      dateNow == selDay[2]
                                          ? Colors.teal
                                          : MyConstant.p3),
                                  MildDateD(
                                      selDay[3].substring(0, 2),
                                      sumWedD,
                                      dateNow == selDay[3]
                                          ? Colors.teal
                                          : MyConstant.p3),
                                  MildDateD(
                                      selDay[4].substring(0, 2),
                                      sumThuD,
                                      dateNow == selDay[4]
                                          ? Colors.teal
                                          : MyConstant.p3),
                                  MildDateD(
                                      selDay[5].substring(0, 2),
                                      sumFriD,
                                      dateNow == selDay[5]
                                          ? Colors.teal
                                          : MyConstant.p3),
                                  MildDateD(
                                      selDay[6].substring(0, 2),
                                      sumSatD,
                                      dateNow == selDay[6]
                                          ? Colors.teal
                                          : MyConstant.p3),
                                ],
                                xValueMapper: (MildDateD score, _) =>
                                    score.playDate,
                                yValueMapper: (MildDateD score, _) =>
                                    score.score,
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                                pointColorMapper: (MildDateD data, _) =>
                                    data.color
                                // enableTooltip: true
                                )
                          ],
                          primaryXAxis: CategoryAxis(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/images/bg.png'),
                          fit: BoxFit.cover)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedButton(
                              height: 40,
                              width: 60,
                              child: Text(
                                '<-',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              color: Colors.blue.shade800,
                              onPressed: () {
                                FlameAudio.playLongAudio('bt2.mp3');
                                setState(() {
                                  weekCount += 7;
                                });
                                selectWeek();
                                graphListWeek();
                              },
                              enabled: true,
                              shadowDegree: ShadowDegree.light,
                              duration: 400,
                            ),
                            SizedBox(
                              width: 60,
                            ),
                            AnimatedButton(
                              height: 40,
                              width: 60,
                              child: Text(
                                '->',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              color: Colors.blue.shade800,
                              onPressed: () {
                                FlameAudio.playLongAudio('bt2.mp3');
                                setState(() {
                                  weekCount -= 7;
                                });
                                selectWeek();
                                graphListWeek();
                              },
                              enabled: true,
                              shadowDegree: ShadowDegree.light,
                              duration: 400,
                            ),
                          ],
                        ),
                        SfCartesianChart(
                          title: ChartTitle(text: '$dateYearWT - $dateYearW'),
                          legend: Legend(isVisible: false),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries>[
                            ColumnSeries<MildDateW, String>(
                                dataSource: [
                                  MildDateW(
                                      selWeek[0].substring(0, 3),
                                      sumSunW,
                                      weekNow == selWeek[0]
                                          ? Colors.teal
                                          : Colors.lightBlue.shade800),
                                  MildDateW(
                                      selWeek[1].substring(0, 3),
                                      sumMonW,
                                      weekNow == selWeek[1]
                                          ? Colors.teal
                                          : Colors.lightBlue.shade800),
                                  MildDateW(
                                      selWeek[2].substring(0, 3),
                                      sumTueW,
                                      weekNow == selWeek[2]
                                          ? Colors.teal
                                          : Colors.lightBlue.shade800),
                                  MildDateW(
                                      selWeek[3].substring(0, 3),
                                      sumWedW,
                                      weekNow == selWeek[3]
                                          ? Colors.teal
                                          : Colors.lightBlue.shade800),
                                  MildDateW(
                                      selWeek[4].substring(0, 3),
                                      sumThuW,
                                      weekNow == selWeek[4]
                                          ? Colors.teal
                                          : Colors.lightBlue.shade800),
                                  MildDateW(
                                      selWeek[5].substring(0, 3),
                                      sumFriW,
                                      weekNow == selWeek[5]
                                          ? Colors.teal
                                          : Colors.lightBlue.shade800),
                                  MildDateW(
                                      selWeek[6].substring(0, 3),
                                      sumSatW,
                                      weekNow == selWeek[6]
                                          ? Colors.teal
                                          : Colors.lightBlue.shade800),
                                ],
                                xValueMapper: (MildDateW score, _) =>
                                    score.playDate,
                                yValueMapper: (MildDateW score, _) =>
                                    score.score,
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                                pointColorMapper: (MildDateW data, _) =>
                                    data.color
                                // enableTooltip: true
                                )
                          ],
                          primaryXAxis: CategoryAxis(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/images/bg.png'),
                          fit: BoxFit.cover)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedButton(
                              height: 40,
                              width: 60,
                              child: Text(
                                '<-',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              color: Colors.blue.shade900,
                              onPressed: () {
                                FlameAudio.playLongAudio('bt2.mp3');
                                setState(() {
                                  monthCount -= 356;
                                  monthC = 0;
                                  monthCC = 0;
                                });
                                selectMonth();
                                graphListMonth();
                              },
                              enabled: true,
                              shadowDegree: ShadowDegree.light,
                              duration: 400,
                            ),
                            SizedBox(
                              width: 60,
                            ),
                            AnimatedButton(
                              height: 40,
                              width: 60,
                              child: Text(
                                '->',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              color: Colors.blue.shade900,
                              onPressed: () {
                                FlameAudio.playLongAudio('bt2.mp3');
                                setState(() {
                                  monthCount += 365;
                                  monthC = 0;
                                  monthCC = 0;
                                });
                                selectMonth();
                                graphListMonth();
                              },
                              enabled: true,
                              shadowDegree: ShadowDegree.light,
                              duration: 400,
                            ),
                          ],
                        ),
                        SfCartesianChart(
                          title: ChartTitle(text: '$dateYearM'),
                          legend: Legend(isVisible: false),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries>[
                            BarSeries<MildDateM, String>(
                              dataSource: [
                                MildDateM(selMonth[11].substring(0, 3), m12),
                                MildDateM(selMonth[10].substring(0, 3), m11),
                                MildDateM(selMonth[9].substring(0, 3), m10),
                                MildDateM(selMonth[8].substring(0, 3), m9),
                                MildDateM(selMonth[7].substring(0, 3), m8),
                                MildDateM(selMonth[6].substring(0, 3), m7),
                                MildDateM(selMonth[5].substring(0, 3), m6),
                                MildDateM(selMonth[4].substring(0, 3), m5),
                                MildDateM(selMonth[3].substring(0, 3), m4),
                                MildDateM(selMonth[2].substring(0, 3), m3),
                                MildDateM(selMonth[1].substring(0, 3), m2),
                                MildDateM(selMonth[0].substring(0, 3), m1),
                              ],
                              xValueMapper: (MildDateM score, _) =>
                                  score.playDate,
                              yValueMapper: (MildDateM score, _) => score.score,
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true),
                              // enableTooltip: true
                            )
                          ],
                          primaryXAxis: CategoryAxis(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class MildDateD {
  MildDateD(this.playDate, this.score, this.color);
  final String playDate;
  final num score;
  final Color color;
}

class MildDateW {
  MildDateW(this.playDate, this.score, this.color);
  final String playDate;
  final num score;
  final Color color;
}

class MildDateM {
  MildDateM(this.playDate, this.score);
  final String playDate;
  final num score;
}
