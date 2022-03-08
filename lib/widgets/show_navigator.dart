import 'package:animated_button/animated_button.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class ShowNavigator extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String routeState;
  final Color color;
  final Color colorFont;
  const ShowNavigator({
    Key? key,
    required this.iconData,
    required this.label,
    required this.routeState,
    required this.color,
    required this.colorFont,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedButton(
        width: 350,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10),
              Icon(
                iconData,
                color: colorFont,
              ),
              SizedBox(width: 20),
              Text(
                '$label',
                style: TextStyle(
                  fontSize: 22,
                  color: colorFont,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, routeState);
          FlameAudio.playLongAudio('bt1.mp3');
        },
        shadowDegree: ShadowDegree.light,
        color: color,
      ),
    );
  }
}
