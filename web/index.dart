library TOTC;

import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:async';
import 'package:stagexl/stagexl.dart';

part 'source/game.dart';
part 'source/fleet.dart';
part 'source/boat.dart';
part 'source/touch.dart';

void main() {

  // setup the Stage and RenderLoop
  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var resourceManager = new ResourceManager();
  resourceManager.addBitmapData("BoatDown", "images/boat_down.png");
  resourceManager.addBitmapData("BoatUp", "images/boat_up.png");
  resourceManager.addBitmapData("Background", "images/background.png");
  
  resourceManager.load().then((res) {
    var game = new Game(resourceManager, stage.juggler);
    stage.addChild(game);
  });
}