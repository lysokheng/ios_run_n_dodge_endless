import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ios_run_n_dodge_h8_endless/game/boy.dart';
import 'package:ios_run_n_dodge_h8_endless/main.dart';
import 'package:ios_run_n_dodge_h8_endless/utils/enemy_generator.dart';

class TinyGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Boy boy;
  late ParallaxComponent parallaxComponent;
  late EnemyGenerator enemyGenerator;
  late TextComponent scoreComponent;
  late TextComponent scoreTitle;
  late double score;

  bool isPaused = false;
  double currentSpeed = .2;

  TinyGame() {
    enemyGenerator = EnemyGenerator();
    scoreComponent = TextComponent();
    scoreTitle = TextComponent();
  }

  @override
  FutureOr<void> onLoad() async {
    boy = await Boy.create();
    parallaxComponent = await loadParallaxComponent(
      [
        ParallaxImageData('background/1.png'),
        ParallaxImageData('background/2.png'),
        ParallaxImageData('background/2.1.png'),
        ParallaxImageData('background/3.png'),
        ParallaxImageData('background/4.png'),
      ],
      baseVelocity: Vector2(currentSpeed, 0),
      velocityMultiplierDelta: Vector2(4, 1.0),
    );

    score = 0;

    scoreComponent = TextComponent(
      text: 'Score: ${score.toStringAsFixed(0)}',
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(style: textStyle),
    );

    addAll([
      parallaxComponent,
      boy,
      boy.dust,
      enemyGenerator,
      scoreTitle,
      scoreComponent,
    ]);

    overlays.add('Pause Button');
    overlays.add("Lives");

    onGameResize(canvasSize);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    scoreTitle.x = (size.x - scoreComponent.width - scoreTitle.width) / 2;
    scoreTitle.y = 15.w;

    scoreComponent.x = (size.x - scoreComponent.width) / 2;
    scoreComponent.y = 15.w;
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    gameOver();
    score += 60 * dt;
    scoreComponent.text = score.toStringAsFixed(0);

    if (boy.onGround) {
      boy.dust.runDust();
    }
    if (!boy.onGround) {
      boy.dust.jumpDust();
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownInfo info) {
    boy.jump();
    super.onTapDown(info);
  }

  void gameOver() async {
    if (boy.life.value < 1) {
      enemyGenerator.removeAllEnemy();
      scoreComponent.removeFromParent();
      scoreTitle.removeFromParent();
      boy.die();
      await Future.delayed(const Duration(milliseconds: 500));
      overlays.add('Game Over');
      pauseEngine();
    }
  }
}
