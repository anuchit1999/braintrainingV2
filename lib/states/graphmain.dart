import 'package:flutter/material.dart';
import 'package:project_game/utility/my_constant.dart';
import 'package:project_game/widgets/show_navigator.dart';

class GraphMain extends StatefulWidget {
  GraphMain({Key? key}) : super(key: key);

  @override
  State<GraphMain> createState() => _GraphMainState();
}

class _GraphMainState extends State<GraphMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: ShowNavigator(
                  iconData: Icons.filter_1,
                  label: 'Graph Rabbit Counting',
                  routeState: MyConstant.routeGraphBird,
                  color: MyConstant.p3,
                  colorFont: Colors.white,
                ),
              ),
              Container(
                child: ShowNavigator(
                  iconData: Icons.filter_2,
                  label: 'Graph Box Counting',
                  routeState: MyConstant.routeGraphBox,
                  color: MyConstant.p3,
                  colorFont: Colors.white,
                ),
              ),
              Container(
                child: ShowNavigator(
                  iconData: Icons.filter_3,
                  label: 'Graph Flag Raising',
                  routeState: MyConstant.routeGraphFlag,
                  color: MyConstant.p3,
                  colorFont: Colors.white,
                ),
              ),
              Container(
                child: ShowNavigator(
                  iconData: Icons.filter_4,
                  label: 'Graph Finger Math',
                  routeState: MyConstant.routeGraphFingermath,
                  color: MyConstant.p3,
                  colorFont: Colors.white,
                ),
              ),
              Container(
                child: ShowNavigator(
                  iconData: Icons.filter_5,
                  label: 'Graph Rock Paper Scissors',
                  routeState: MyConstant.routeGraphRock,
                  color: MyConstant.p3,
                  colorFont: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
