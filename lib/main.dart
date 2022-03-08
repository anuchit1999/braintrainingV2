import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:project_game/pageAuth/home.dart';
import 'package:project_game/pageAuth/pageMenu.dart';
import 'package:project_game/states/count_timebird.dart';
import 'package:project_game/states/count_timebox.dart';
import 'package:project_game/states/count_timefingermaths.dart';
import 'package:project_game/states/count_timeflagraising.dart';
import 'package:project_game/states/count_timerock.dart';
import 'package:project_game/states/edit_profile.dart';
import 'package:project_game/states/game_bird.dart';
import 'package:project_game/states/game_box.dart';
import 'package:project_game/states/game_flagraising.dart';
import 'package:project_game/states/graph_bird.dart';
import 'package:project_game/states/graph_box.dart';
import 'package:project_game/states/graph_fingermath.dart';
import 'package:project_game/states/graph_flag.dart';
import 'package:project_game/states/graph_rock.dart';
import 'package:project_game/states/graphmain.dart';
import 'package:project_game/states/intro_fingermaths.dart';
import 'package:project_game/states/intro_bird.dart';
import 'package:project_game/states/intro_box.dart';
import 'package:project_game/states/intro_flagraising.dart';
import 'package:project_game/states/intro_rock.dart';
import 'package:project_game/states/multiplayer/createroom.dart';
import 'package:project_game/states/multiplayer/findroom.dart';
import 'package:project_game/states/multiplayer/multigame_bird.dart';
import 'package:project_game/states/multiplayer/multigame_box.dart';
import 'package:project_game/states/multiplayer/multimain.dart';
import 'package:project_game/states/multiplayer/prebird.dart';
import 'package:project_game/states/multiplayer/prebox.dart';
import 'package:project_game/states/multiplayer/result_game.dart';
import 'package:project_game/states/multiplayer/room.dart';
import 'package:project_game/states/multiplayer/roomuser.dart';
import 'package:project_game/states/profile.dart';
import 'package:project_game/states/realtime_camera/live_Rock.dart';
import 'package:project_game/states/realtime_camera/live_finger.dart';
import 'package:project_game/states/result_bird.dart';
import 'package:project_game/states/result_box.dart';
import 'package:project_game/states/result_fingermaths.dart';
import 'package:project_game/states/result_flagraising.dart';
import 'package:project_game/states/result_rock.dart';
import 'package:project_game/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/services.dart';

List<CameraDescription>? cameras;
Map<String, WidgetBuilder> map = {
  MyConstant.routeHome: (BuildContext context) => HomeScreen(),
  MyConstant.routePagemenu: (BuildContext context) => PageMenu(),
  MyConstant.routeIntroBird: (BuildContext context) => IntroBird(),
  MyConstant.routeCountTimeBird: (BuildContext context) => CountTimeBird(),
  MyConstant.routeGameBird: (BuildContext context) => GameBird(),
  MyConstant.routeResultBird: (BuildContext context) => ResultBird(),
  MyConstant.routeIntroBox: (BuildContext context) => IntroBox(),
  MyConstant.routeCountTimeBox: (BuildContext context) => CountTimeBox(),
  MyConstant.routeGameBox: (BuildContext context) => GameBox(),
  MyConstant.routeResultBox: (BuildContext context) => ResultBox(),
  MyConstant.routeIntroFlagraising: (BuildContext context) =>
      IntroFlagraising(),
  MyConstant.routeCountTimeFlagraising: (BuildContext context) =>
      CountTimeFlagraising(),
  MyConstant.routeGameFlagraising: (BuildContext context) => GameFlagraising(),
  MyConstant.routeResultFlagraising: (BuildContext context) =>
      ResultFlagraising(),
  MyConstant.routeIntroFingermath: (BuildContext context) => IntroFingermath(),
  MyConstant.routeCountTimeFingermath: (BuildContext context) =>
      CountTimeFingermath(),
  MyConstant.routeLiveFeedFingermaths: (BuildContext context) =>
      LiveFeedFingermaths(cameras!),
  MyConstant.routeResultFingermaths: (BuildContext context) =>
      ResultFingermath(),
  MyConstant.routeIntroRock: (BuildContext context) => IntroRock(),
  MyConstant.routeCountTimeRock: (BuildContext context) => CountTimeRock(),
  MyConstant.routeLiveFeedRock: (BuildContext context) =>
      LiveFeedRock(cameras!),
  MyConstant.routeResultRock: (BuildContext context) => ResultRock(),
  MyConstant.routeProfile: (BuildContext context) => Profile(),
  MyConstant.routeEditProfile: (BuildContext context) => EditProfile(),
  MyConstant.routeGraphBird: (BuildContext context) => GraphBird(),
  MyConstant.routeGraphBox: (BuildContext context) => GraphBox(),
  MyConstant.routeGraphFlag: (BuildContext context) => GraphFlag(),
  MyConstant.routeGraphFingermath: (BuildContext context) => GraphFingermath(),
  MyConstant.routeGraphRock: (BuildContext context) => GraphRock(),
  MyConstant.routecreateRoom: (BuildContext context) => createRoom(),
  MyConstant.routefindRoom: (BuildContext context) => findRoom(),
  MyConstant.routeroomGame: (BuildContext context) => roomGame(),
  MyConstant.routeroomUser: (BuildContext context) => roomUser(),
  MyConstant.routemultiMain: (BuildContext context) => multiMain(),
  MyConstant.routeMulti_GameBird: (BuildContext context) => Multi_GameBird(),
  MyConstant.routeMulti_GameBox: (BuildContext context) => Multi_GameBox(),
  MyConstant.routePreBird: (BuildContext context) => PreBird(),
  MyConstant.routePreBox: (BuildContext context) => PreBox(),
  MyConstant.routeResultMultiGame: (BuildContext context) => ResultMultiGame(),
  MyConstant.routeOnboardingPageState: (BuildContext context) =>
      OnboardingPage(),
  MyConstant.routeMainPage: (BuildContext context) => MainPage(),
  MyConstant.routeGraphMain: (BuildContext context) => GraphMain(),
};

String? firstState;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  cameras = await availableCameras();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp().then((value) async {
    // ignore: await_only_futures
    await FirebaseAuth.instance.authStateChanges().listen((event) {
      if (showHome) {
        if (event == null) {
          firstState = MyConstant.routeHome;
          runApp(MyApp());
        } else {
          firstState = MyConstant.routeMainPage;
          runApp(MyApp());
        }
      } else {
        firstState = MyConstant.routeOnboardingPageState;
        runApp(MyApp());
      }
    });
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      routes: map,
      initialRoute: firstState,
    );
  }
}

// function getstart
class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 4);
            },
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 10),
                color: MyConstant.p1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'asset/images/brain5.png',
                      fit: BoxFit.cover,
                      width: 200,
                    ),
                    const SizedBox(height: 64),
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
                          top: 10, left: 10, right: 10, bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            'BrainTraining',
                            style: TextStyle(
                              color: MyConstant.p1,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 48),
                            child: Text(
                              'แอพพลิเคชันนี้เป็นแอพพลิเคชันที่สามารถช่วยฝึกสมองให้กับผู้เล่น ซึ่งมีเกมให้เลือกเล่นหลายเกม ในแต่ล่ะเกมนั้นจะช่วยฝึกสมองในด้านที่แตกต่างกันไป',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 1
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 10),
                color: Colors.indigo[300],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'asset/images/brain1.gif',
                      fit: BoxFit.cover,
                      width: 200,
                    ),
                    const SizedBox(height: 64),
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
                          top: 10, left: 10, right: 10, bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            'สมองส่วนหน้า',
                            style: TextStyle(
                              color: Colors.purple.shade900,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 48),
                            child: Text(
                              'สมองกลีบหน้า ( Frontal Lobe ) ทำหน้าที่เกี่ยวข้องกับความคิด การตัดสินใจ สติปัญญา บุคลิก ความรู้สึก การพูด การใช้ภาษาและ  การออกเสียง',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 2
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 10),
                color: MyConstant.p2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'asset/images/brain2.gif',
                      fit: BoxFit.cover,
                      width: 200,
                    ),
                    const SizedBox(height: 64),
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
                          top: 10, left: 10, right: 10, bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            'สมองส่วนขมับ',
                            style: TextStyle(
                              color: Colors.teal.shade700,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 48),
                            child: Text(
                              'สมองกลีบขมับ ( Temporal Lobe ) ซีกซ้ายจะทำหน้าที่รับรู้และเข้าใจภาษา ส่วนซีกขวาจะเกี่ยวข้องกับการเข้าใจเสียงสูงต่ำในประโยค หรือในบทเพลง',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 3
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 10),
                color: MyConstant.p3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'asset/images/brain3.gif',
                      fit: BoxFit.cover,
                      width: 200,
                    ),
                    const SizedBox(height: 64),
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
                          top: 10, left: 10, right: 10, bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            'สมองพาไรเอทัล',
                            style: TextStyle(
                              color: Colors.blueAccent.shade700,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 48),
                            child: Text(
                              'สมองกลีบข้างขม่อม หรือ กระหม่อม ( Parietal Lobe ) ทำหน้าที่เกี่ยวกับการรับรู้ การสัมผัส การรับรส ความเข้าใจในการสัมพันธ์ของร่างกายและสิ่งแวดล้อม',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 4
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 10),
                color: MyConstant.p4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'asset/images/brain4.gif',
                      fit: BoxFit.cover,
                      width: 200,
                    ),
                    const SizedBox(height: 64),
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
                          top: 10, left: 0, right: 0, bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            'สมองส่วนหลัง',
                            style: TextStyle(
                              color: Colors.indigo.shade900,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 48),
                            child: Text(
                              'สมองกลีบท้ายทอย ( Occipital Lobe )\nทำหน้าที่เกี่ยวกับการเห็นภาพ ซึ่งเชื่อมโยงสัมพันธ์กับสมองกลีบข้างขม่อม คือเมื่อมองเห็นแล้วก็รับรู้ได้ว่าสิ่งที่เห็นนั้นคืออะไร',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomSheet: isLastPage
            ? TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  primary: Colors.white,
                  backgroundColor: Colors.teal.shade700,
                  minimumSize: const Size.fromHeight(80),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () async {
                  // navigate directly to home page
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('showHome', true);

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: const Text('SKIP'),
                      onPressed: () => controller.jumpToPage(3),
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: 4,
                        effect: WormEffect(
                          spacing: 16,
                          dotColor: Colors.black26,
                          activeDotColor: Colors.teal.shade700,
                        ),
                        onDotClicked: (index) => controller.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        ),
                      ),
                    ),
                    TextButton(
                      child: const Text('NEXT'),
                      onPressed: () => controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ],
                ),
              ),
      );
}

// function navbar
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;

  final screens = [
    PageMenu(),
    multiMain(),
    GraphMain(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home, size: 30),
      Icon(Icons.group, size: 30),
      Icon(Icons.auto_graph_sharp, size: 30),
      Icon(Icons.person, size: 30),
    ];

    /// For iOS platform: SafeArea and ClipRect needed
    return Container(
      color: Colors.blue,
      child: SafeArea(
        top: false,
        child: ClipRect(
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: screens[index],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(color: Colors.white),
              ),
              child: CurvedNavigationBar(
                key: navigationKey,
                color: index == 3
                    ? MyConstant.p4
                    : index == 2
                        ? MyConstant.p3
                        : index == 1
                            ? MyConstant.p2
                            : MyConstant.p1,
                buttonBackgroundColor: index == 3
                    ? MyConstant.p4
                    : index == 2
                        ? MyConstant.p3
                        : index == 1
                            ? MyConstant.p2
                            : MyConstant.p1,
                backgroundColor: Colors.transparent,
                height: 60,
                animationCurve: Curves.easeInOut,
                animationDuration: Duration(milliseconds: 1000),
                index: index,
                items: items,
                onTap: (index) {
                  setState(() => this.index = index);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
