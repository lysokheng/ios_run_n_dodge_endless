import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ios_run_n_dodge_h8_endless/constants/audio_path.dart';
import 'package:ios_run_n_dodge_h8_endless/constants/image_path.dart';
import 'package:ios_run_n_dodge_h8_endless/controllers/controllers.dart';
import 'package:ios_run_n_dodge_h8_endless/game/game.dart';
import 'package:ios_run_n_dodge_h8_endless/main.dart';
import 'package:ios_run_n_dodge_h8_endless/utils/enemy_generator.dart';
import 'package:ios_run_n_dodge_h8_endless/views/home_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

Widget gameOver(BuildContext context, TinyGame gameref) {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(gameref.size.y - gameref.size.y * 90 / 100),
      child: Stack(alignment: Alignment.center, children: [
        Image.asset(
          imgGameOver,
          width: 500.w,
        ),
        Positioned(
          child: Text('Score:\n${gameref.score.toStringAsFixed(0)}',
              style: textStyle),
        ),
        Positioned(
          bottom: 35.w,
          child: Row(
            children: [
              ZoomTapAnimation(
                  onTap: () {
                    gameController.tapSound.play(soundTap);

                    gameref.overlays.remove('Game Over');

                    gameref.enemyGenerator.resetTimer();
                    EnemyGenerator.spawnLevel = 0;
                    gameref.enemyGenerator.removeAllEnemy();
                    gameref.score = 0;
                    gameref.boy.life.value = 3;
                    gameref
                        .addAll([gameref.scoreTitle, gameref.scoreComponent]);
                    gameref.currentSpeed = 0.2;
                    gameref.parallaxComponent.parallax?.baseVelocity =
                        Vector2(gameref.currentSpeed, 0);

                    gameref.resumeEngine();
                  },
                  child: Image.asset(
                    imgRetry,
                    height: 40.h,
                  )),
              SizedBox(
                width: 30.h,
              ),
              ZoomTapAnimation(
                  onTap: () {
                    gameController.tapSound.play(soundTap);

                    Get.offAll(() => HomeScreen());
                  },
                  child: Image.asset(
                    imgMainMenu,
                    height: 40.h,
                  ))
            ],
          ),
        ),
      ]),
    ),
  );
}
