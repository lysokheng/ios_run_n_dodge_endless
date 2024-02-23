import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';

enum EnemyType { dinosure, tiger, dragon }

class EnemyDetails {
  final String image;
  final bool canFly;
  final int speed;
  final Vector2 size;

  EnemyDetails({
    required this.image,
    required this.canFly,
    required this.speed,
    required this.size,
  });
}

class Enemy extends SpriteAnimationComponent with CollisionCallbacks {
  static late EnemyDetails? enemyData;
  static late SpriteAnimation _runAnimation;
  static final _random = Random();

  static Map<EnemyType, EnemyDetails> enemyDetails = {
    EnemyType.dinosure: EnemyDetails(
      image: 'enemies/enemy-1 260 x 170.png',
      canFly: false,
      speed: 350,
      size: Vector2(260, 170),
    ),
    EnemyType.dragon: EnemyDetails(
      image: 'enemies/enemy-1 349 x 388.png',
      canFly: true,
      speed: 300,
      size: Vector2(349, 388),
    ),
    EnemyType.tiger: EnemyDetails(
      image: 'enemies/enemy-2 246 x 260.png',
      canFly: false,
      speed: 200,
      size: Vector2(246, 260),
    ),
  };

  Enemy();

  static Future<Enemy> create(EnemyType enemyType) async {
    final enemy = Enemy();
    enemyData = enemyDetails[enemyType];

    // Run Animation initialization
    Image enemyRunImage = await Flame.images.load(enemyData!.image);
    final runSprite =
        SpriteSheet(image: enemyRunImage, srcSize: enemyData!.size);
    _runAnimation = runSprite.createAnimation(row: 0, stepTime: 0.1);

    enemy.animation = _runAnimation;

    return enemy;
  }

  @override
  void onGameResize(Vector2 size) {
    height = width = size.y / 8;
    x = size.x + width;
    y = size.y - size.y * 22 / 100;

    if (enemyData!.canFly && _random.nextBool()) {
      y -= height;
    }
    super.onGameResize(size);
  }

  @override
  void onMount() {
    add(RectangleHitbox.relative(Vector2(.6, .8), parentSize: size));

    super.onMount();
  }

  @override
  void update(double dt) {
    //x -= enemyData?.speed ?? 0 * dt;
    x -= enemyData!.speed * dt;
    if (x < -width) {
      removeFromParent();
    }
    super.update(dt);
  }
}
