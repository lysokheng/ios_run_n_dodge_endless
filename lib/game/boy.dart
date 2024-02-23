import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' as mt;
import 'package:ios_run_n_dodge_h8_endless/constants/audio_path.dart';
import 'package:ios_run_n_dodge_h8_endless/game/enemy.dart';

import '../controllers/controllers.dart';
import 'dust.dart';

class Boy extends SpriteAnimationComponent with CollisionCallbacks {
  late Dust dust; // Dust of the Boy

  static late SpriteAnimation _idleAnimation;
  static late SpriteAnimation _runAnimation;
  static late SpriteAnimation _hurtAnimation;
  static late SpriteAnimation _deathAnimation;

  static const gravity = 1000;
  late double speedY, initialV;
  late mt.ValueNotifier<int> life;
  late Timer _timer;
  double skyToGround = 0.0;
  bool isHit = false;

  Boy() {
    life = mt.ValueNotifier(3);
    _timer = Timer(
      1,
      onTick: () {
        isHit = false;
        run();
      },
    );
  }

  static Future<Boy> create() async {
    final hero = Boy();
    Image boyIdleImage = await Flame.images.load('boy/Boy_Jump9(139x133).png');
    final idleSprite =
        SpriteSheet(image: boyIdleImage, srcSize: Vector2(139, 133));
    _idleAnimation = idleSprite.createAnimation(
        row: 0, stepTime: .1, from: 0, loop: false, to: 7);

    // Run Animation initialization
    Image boyRunImage = await Flame.images.load('boy/Boy_Run6(139x133).png');
    final runSprite =
        SpriteSheet(image: boyRunImage, srcSize: Vector2(139, 133));
    _runAnimation = runSprite.createAnimation(row: 0, stepTime: 0.1);

    // Hurt Animation initialization
    Image boyHurtImage = await Flame.images.load('boy/Boy_Hurt3(139x133).png');
    final hurtSprite =
        SpriteSheet(image: boyHurtImage, srcSize: Vector2(139, 133));
    _hurtAnimation = hurtSprite.createAnimation(row: 0, stepTime: 0.1);

    // Death Animation initialization
    Image boyDeathImage = await Flame.images.load('boy/Boy_Die5(139x133).png');
    final deathSprite =
        SpriteSheet(image: boyDeathImage, srcSize: Vector2(139, 133));
    _deathAnimation = deathSprite.createAnimation(
        row: 0, stepTime: 0.1, from: 0, to: 5, loop: false);

    hero.animation = _runAnimation;

    hero.dust = await Dust.create();
    return hero;
  }

  @override
  void onGameResize(Vector2 size) {
    speedY = initialV = -100 - (size.y);
    height = width = size.y / 7;
    x = size.x - size.x * 81 / 100;
    y = size.y - size.y * 24 / 100;
    skyToGround = y;
    super.onGameResize(size);
  }

  @override
  void onMount() {
    add(RectangleHitbox.relative(Vector2(.6, .8), parentSize: size));
    super.onMount();
  }

  @override
  void update(double dt) {
    speedY += gravity * dt;
    var distance = speedY * dt;
    y += distance;

    if (onGround) {
      run();

      y = skyToGround;
      speedY = 0.0;
    }

    _timer.update(dt);

    super.update(dt);
  }

  bool get onGround => y >= skyToGround;

  void idle() {
    animation = _idleAnimation;
  }

  void run() {
    if (!isHit) {
      animation = _runAnimation;
    }
  }

  void hurt() {
    gameController.tapSound.play(soundHurt);

    animation = _hurtAnimation;
  }

  void die() {
    gameController.tapSound.play(soundDie);

    animation = _deathAnimation;
  }

  void jump() {
    gameController.tapSound.play(soundJump);

    if (onGround) {
      !isHit ? idle() : hurt();
      idle();
      speedY = initialV;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Enemy && !isHit) {
      hurt();
      life.value -= 1;
      isHit = true;
      _timer.start();
    }
    super.onCollision(intersectionPoints, other);
  }
}
