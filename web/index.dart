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
part 'source/slider.dart';
part 'source/graph.dart';
part 'source/offseason.dart';
part 'source/regrowthUI.dart';

void main() {
  int height = html.window.innerHeight-20;
  int width = html.window.innerWidth;
  
  var canvas = html.querySelector('#stage');
  canvas.width = width;
  canvas.height = height+16;
  
  var stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var resourceManager = new ResourceManager();
  resourceManager.addBitmapData("BoatASardineDown", "images/boat_sardine_a_touched.png");
  resourceManager.addBitmapData("BoatASardineUp", "images/boat_sardine_a.png");
  resourceManager.addBitmapData("BoatATunaDown", "images/boat_tuna_a_touched.png");
  resourceManager.addBitmapData("BoatATunaUp", "images/boat_tuna_a.png");
  resourceManager.addBitmapData("BoatASharkDown", "images/boat_shark_a_touched.png");
  resourceManager.addBitmapData("BoatASharkUp", "images/boat_shark_a.png");
  resourceManager.addBitmapData("BoatBSardineDown", "images/boat_sardine_b_touched.png");
  resourceManager.addBitmapData("BoatBSardineUp", "images/boat_sardine_b.png");
  resourceManager.addBitmapData("BoatBTunaDown", "images/boat_tuna_b_touched.png");
  resourceManager.addBitmapData("BoatBTunaUp", "images/boat_tuna_b.png");
  resourceManager.addBitmapData("BoatBSharkDown", "images/boat_shark_b_touched.png");
  resourceManager.addBitmapData("BoatBSharkUp", "images/boat_shark_b.png");
  resourceManager.addTextureAtlas("Nets", "images/nets.json", TextureAtlasFormat.JSONARRAY);
  resourceManager.addBitmapData("Background", "images/background.png");
  resourceManager.addBitmapData("OffseasonBackground", "images/offseason_background.png");
  resourceManager.addBitmapData("Mask", "images/mask.png");
  resourceManager.addBitmapData("Tuna", "images/tuna.png");
  resourceManager.addBitmapData("Shark", "images/shark.png");
  resourceManager.addBitmapData("Sardine", "images/sardine.png");
  resourceManager.addBitmapData("SardineBlood", "images/sardine_blood.png");
  resourceManager.addBitmapData("TunaBlood", "images/tuna_blood.png");
  resourceManager.addBitmapData("Console", "images/console.png");
  resourceManager.addBitmapData("CapacityDown", "images/capacity_down.png");
  resourceManager.addBitmapData("CapacityUp", "images/capacity_up.png");
  resourceManager.addBitmapData("SpeedDown", "images/speed_down.png");
  resourceManager.addBitmapData("SpeedUp", "images/speed_up.png");
  resourceManager.addBitmapData("SellDown", "images/sell_down.png");
  resourceManager.addBitmapData("SellUp", "images/sell_up.png");
  resourceManager.addBitmapData("BuyDown", "images/buy_down.png");
  resourceManager.addBitmapData("BuyUp", "images/buy_up.png");
  resourceManager.addBitmapData("NoDown", "images/no_down.png");
  resourceManager.addBitmapData("NoUp", "images/no_up.png");
  resourceManager.addBitmapData("OkayDown", "images/okay_down.png");
  resourceManager.addBitmapData("OkayUp", "images/okay_up.png");
  resourceManager.addBitmapData("YesDown", "images/yes_down.png");
  resourceManager.addBitmapData("YesUp", "images/yes_up.png");
  resourceManager.addBitmapData("GraphBackground", "images/graph.png");
  resourceManager.addBitmapData("Arrow", "images/arrow.png");
  resourceManager.addBitmapData("TeamACircle", "images/teamACircle.png");
  resourceManager.addBitmapData("TeamBCircle", "images/teamBCircle.png");
  resourceManager.addBitmapData("CircleButtonUpA", "images/circleUIButtonA.png");
  resourceManager.addBitmapData("CircleButtonDownA", "images/circleUIButtonDownA.png");
  resourceManager.addBitmapData("CircleButtonUpB", "images/circleUIButtonB.png");
  resourceManager.addBitmapData("CircleButtonDownB", "images/circleUIButtonDownB.png");
  resourceManager.addBitmapData("SardineBoatButton", "images/sardineBoatIcon.png");
  resourceManager.addBitmapData("TunaBoatButton", "images/tunaBoatIcon.png");
  resourceManager.addBitmapData("SharkBoatButton", "images/sharkBoatIcon.png");
  resourceManager.addBitmapData("CapacityUpgradeButton", "images/capUpgradeIcon.png");
  resourceManager.addBitmapData("SpeedUpgradeButton", "images/speedUpgradeIcon.png");
  resourceManager.addBitmapData("OffseasonDock", "images/offseason_dock.png");
  resourceManager.addBitmapData("sardineIcon", "images/sardineIcon.png");
  resourceManager.addBitmapData("tunaIcon", "images/tunaIcon.png");
  resourceManager.addBitmapData("sharkIcon", "images/sharkIcon.png");
  resourceManager.addBitmapData("timer", "images/timer.png");
  resourceManager.addBitmapData("foodWeb", "images/foodWeb.png");
  resourceManager.addBitmapData("stars0", "images/stars0.png");
  resourceManager.addBitmapData("stars1", "images/stars1.png");
  resourceManager.addBitmapData("stars2", "images/stars2.png");
  resourceManager.addBitmapData("stars3", "images/stars3.png");
  resourceManager.addBitmapData("badgeExtinct", "images/extinctBadge.png");
  resourceManager.addBitmapData("badgeLeastConcern", "images/leastConcernBadge.png");
  resourceManager.addBitmapData("badgeOverpopulated", "images/overpopulatedBadge.png");
  resourceManager.addBitmapData("badgeEndangered", "images/endangeredBadge.png");
  
  Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
  
  resourceManager.load().then((res) {
    var game = new Game(resourceManager, stage.juggler, width, height);
    stage.addChild(game);
    stage.juggler.add(game);
  });
}