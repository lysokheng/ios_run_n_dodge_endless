import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class GameController extends GetxController {
  RxBool isStart = false.obs;
  RxBool isPause = false.obs;

  RxInt heart = 5.obs;
  RxBool hasSound = true.obs;
  RxBool hasMusic = true.obs;
  RxBool isReady = false.obs;
  //audio
  AudioPlayer tapSound = AudioPlayer();
  AudioPlayer dieSound = AudioPlayer();
  AudioPlayer hurtSound = AudioPlayer();
  AudioPlayer jumpSound = AudioPlayer();
}
