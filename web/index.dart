library TOTC;

import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:async';

import 'package:stagexl/stagexl.dart';

part 'source/game.dart';
part 'source/touch.dart';
part 'source/fleet.dart';
part 'source/boat.dart';
part 'source/net.dart';
part 'source/ecosystem.dart';
part 'source/fish.dart';
part 'source/movement.dart';
part 'source/console.dart';

void main() {
  int height = html.window.innerHeight-20;
  int width = html.window.innerWidth;
  
  var canvas = html.querySelector('#stage');
  canvas.width = width;
  canvas.height = height;
  
  var stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var resourceManager = new ResourceManager();
  resourceManager.addBitmapData("BoatADown", "images/boat_a_down.png");
  resourceManager.addBitmapData("BoatAUp", "images/boat_a_up.png");
  resourceManager.addBitmapData("BoatBDown", "images/boat_b_down.png");
  resourceManager.addBitmapData("BoatBUp", "images/boat_b_up.png");
  resourceManager.addTextureAtlas("Nets", "images/nets.json", TextureAtlasFormat.JSONARRAY);
  resourceManager.addBitmapData("Background", "images/background.png");
  resourceManager.addBitmapData("Mask", "images/mask.png");
  resourceManager.addBitmapData("Tuna", "images/tuna.png");
  resourceManager.addBitmapData("Shark", "images/shark.png");
  resourceManager.addBitmapData("Sardine", "images/sardine.png");
  resourceManager.addBitmapData("SardineBlood", "images/sardine_blood.png");
  resourceManager.addBitmapData("TunaBlood", "images/tuna_blood.png");
  resourceManager.addBitmapData("Dock", "images/dock.png");
  resourceManager.addBitmapData("Console", "images/console.png");
  resourceManager.addBitmapData("CapacityDown", "images/capacity_down.png");
  resourceManager.addBitmapData("CapacityUp", "images/capacity_up.png");
  resourceManager.addBitmapData("SpeedDown", "images/speed_down.png");
  resourceManager.addBitmapData("SpeedUp", "images/speed_up.png");
  resourceManager.addBitmapData("SellDown", "images/sell_down.png");
  resourceManager.addBitmapData("SellUp", "images/sell_up.png");
  resourceManager.addBitmapData("BuyDown", "images/buy_down.png");
  resourceManager.addBitmapData("BuyUp", "images/buy_up.png");
  
  resourceManager.load().then((res) {
    var game = new Game(resourceManager, stage.juggler, width, height);
    stage.addChild(game);
    stage.juggler.add(game);
  });
  
 Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
}