import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ios_run_n_dodge_h8_endless/game/game.dart';

class Lives extends StatelessWidget {
  const Lives({super.key, required this.gameRef});

  final MainGame gameRef;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: gameRef.boy.life,
      builder: (context, value, child) {
        List<Widget> list = [];
        for (int i = 0; i < 3; i++) {
          list.add(Icon(
            Icons.favorite,
            color: i < value ? Colors.red : Colors.blueGrey,
            size: gameRef.size.y / 10,
          ));
        }
        return Padding(
          padding: EdgeInsets.only(
            top: 15.w,
            right: 15.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: list,
          ),
        );
      },
    );
  }
}
