import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ios_run_n_dodge_h8_endless/constants/audio_path.dart';
import 'package:ios_run_n_dodge_h8_endless/constants/image_path.dart';
import 'package:ios_run_n_dodge_h8_endless/controllers/controllers.dart';
import 'package:ios_run_n_dodge_h8_endless/views/game_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Flame.device.setLandscape();
    Flame.device.fullScreen();
    Flame.device.setLandscape();
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              imgBg,
            ),
            fit: BoxFit.fill),
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const SizedBox(),
        Column(
          children: [
            ZoomTapAnimation(
                onTap: () async {
                  gameController.tapSound.play(soundTap);
                  Get.offAll(() => const GameScreen());
                },
                child: Image.asset(
                  imgPlay,
                  width: 200.h,
                )),
            SizedBox(
              height: 15.w,
            ),
            ZoomTapAnimation(
                onTap: () {
                  gameController.tapSound.play(soundTap);
                  FlutterExitApp.exitApp();
                },
                child: Image.asset(
                  imgQuit,
                  width: 200.h,
                )),
          ],
        ),
        const SizedBox(),
      ]),
    );
  }
}
