import 'dart:math';

import 'package:flame/components.dart';
import 'package:ios_run_n_dodge_h8_endless/game/enemy.dart';
import 'package:ios_run_n_dodge_h8_endless/game/game.dart';

class EnemyGenerator extends Component with HasGameReference<MainGame> {
  late Random _rand;
  late Timer _timer;
  static int spawnLevel = 0;

  EnemyGenerator() {
    _rand = Random();
    resetTimer();
  }

  void resetTimer() {
    _timer = Timer(
      3,
      repeat: true,
      onTick: () {
        spawnEnemy();
      },
    );
  }

  void spawnEnemy() async {
    final number = _rand.nextInt(EnemyType.values.length);
    final enemyType = EnemyType.values.elementAt(number);
    final enemy = await Enemy.create(enemyType);
    game.add(enemy);
  }

  @override
  void onMount() {
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);

    var newSpawnLevel = game.score ~/ 300;
    if (newSpawnLevel > spawnLevel) {
      spawnLevel = newSpawnLevel;
      game.parallaxComponent.parallax?.baseVelocity =
          Vector2(game.currentSpeed += spawnLevel / 500, 0);
      var newWaitTime = (4 / (1 + (0.1 * spawnLevel)));
      _timer.stop();
      _timer = Timer(newWaitTime, repeat: true, onTick: () {
        spawnEnemy();
      });
      _timer.start();
    }
    super.update(dt);
  }

  void removeAllEnemy() {
    final enemies = game.children.whereType<Enemy>();
    for (var enemy in enemies) {
      enemy.removeFromParent();
    }
  }
}
