import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ios_run_n_dodge_h8_endless/constants/audio_path.dart';
import 'package:ios_run_n_dodge_h8_endless/constants/image_path.dart';
import 'package:ios_run_n_dodge_h8_endless/controllers/controllers.dart';
import 'package:ios_run_n_dodge_h8_endless/screens/lives.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../game/game.dart';
import '../screens/game_over.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late TinyGame _game;

  @override
  void initState() {
    super.initState();

    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('music.mp3', volume: 0.5);
    _game = TinyGame();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        loadingBuilder: (p0) => Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    imgBg,
                  ),
                  fit: BoxFit.fill),
            ),
            child: const Center(child: CircularProgressIndicator())),
        game: _game,
        overlayBuilderMap: {
          'Pause Button': header,
          'Lives': (_, __) => Lives(
                gameRef: _game,
              ),
          'Game Over': (_, __) {
            return gameOver(context, _game);
          },
        },
      ),
    );
  }

  Widget header(context, game) {
    return Material(
      elevation: 100,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(left: 15.w, top: 15.w),
        child: Row(
          children: [
            ZoomTapAnimation(
                onTap: () {
                  gameController.tapSound.play(soundTap);

                  playPauseTapped();
                },
                child: Obx(
                  () => Image.asset(
                    gameController.isPause.value ? imgResume : imgPause,
                    width: 30.w,
                  ),
                )),
            SizedBox(
              width: 5.w,
            ),
            ZoomTapAnimation(
              onTap: () {
                gameController.tapSound.play(soundTap);
                if (gameController.hasSound.value) {
                  gameController.tapSound.setVolume(0);
                  gameController.dieSound.setVolume(0);
                  gameController.hurtSound.setVolume(0);
                  gameController.jumpSound.setVolume(0);
                  gameController.hasSound.value = false;
                } else {
                  gameController.tapSound.setVolume(1);
                  gameController.dieSound.setVolume(1);
                  gameController.hurtSound.setVolume(1);
                  gameController.jumpSound.setVolume(1);
                  gameController.hasSound.value = true;
                }
              },
              child: Obx(
                () => Image.asset(
                  gameController.hasSound.value ? imgSoundOn : imgSoundOff,
                  width: 30.w,
                ),
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            ZoomTapAnimation(
              onTap: () {
                gameController.tapSound.play(soundTap);
                if (gameController.hasMusic.value) {
                  FlameAudio.bgm.stop();
                  gameController.hasMusic.value = false;
                } else {
                  FlameAudio.bgm.play('music.mp3', volume: 0.5);

                  gameController.hasMusic.value = true;
                }
              },
              child: Obx(
                () => Image.asset(
                  gameController.hasMusic.value ? imgMusicOn : imgMusicOff,
                  width: 30.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void playPauseTapped() {
    if (_game.isPaused) {
      _animationController.reverse();
      _game.resumeEngine();
      _game.isPaused = false;
      gameController.isPause.value = false;
    } else {
      _animationController.forward();
      _game.pauseEngine();
      _game.isPaused = true;
      gameController.isPause.value = true;
    }
  }
}
