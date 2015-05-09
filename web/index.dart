library TOTC;

import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:async';

import 'package:stagexl/stagexl.dart';
import 'package:stagexl_particle/stagexl_particle.dart';

part 'source/game.dart';
part 'source/touch.dart';
part 'source/fleet.dart';
part 'source/boat.dart';
part 'source/net.dart';
part 'source/ecosystem.dart';
part 'source/fish.dart';
part 'source/movement.dart';
part 'source/console.dart';
//part 'source/slider.dart';
part 'source/graph.dart';
part 'source/offseason.dart';
part 'source/regrowthUI.dart';
part 'source/endgame.dart';
//part 'source/datalogger.dart';
part 'source/title.dart';
part 'source/finalSummary.dart';

html.WebSocket ws;

outputMsg(String msg) {
  
  print(msg);

}


void initWebSocket([int retrySeconds = 2]) {
  var reconnectScheduled = false;

  outputMsg("Connecting to websocket");
  ws = new html.WebSocket('ws://127.0.0.1:4040/ws');

  void scheduleReconnect() {
    if (!reconnectScheduled) {
      new Timer(new Duration(milliseconds: 1000 * retrySeconds), () => initWebSocket(retrySeconds * 2));
    }
    reconnectScheduled = true;
  }

  ws.onOpen.listen((e) {
    outputMsg('Connected');
    ws.send('connected');
  });

  ws.onClose.listen((e) {
    outputMsg('Websocket closed, retrying in $retrySeconds seconds');
    scheduleReconnect();
  });

  ws.onError.listen((e) {
    outputMsg("Error connecting to ws");
    scheduleReconnect();
  });

  ws.onMessage.listen((html.MessageEvent e) {
    outputMsg('Received message: ${e.data}');
  });
}

void main() {
//  int height = html.window.innerHeight-20;
  var densityRatio = html.window.devicePixelRatio;

//  int height = (html.window.screen.available.width * .75).toInt() * densityRatio;
//  int width = html.window.screen.available.width * densityRatio;
  int height = (html.window.innerWidth * .75).toInt() * densityRatio;
  int width = html.window.innerWidth * densityRatio;
  print("HEIGHT: " + height.toString());
  print("WIDTH: " + width.toString());
//  var htmlDoc = html.querySelector('#myBody');
//  int height = (htmlDoc.width * .75).toInt();
//  int width = htmlDoc.width;
  
//  int height = 1536;
//  int width = 2048;
  var canvas = html.querySelector('#stage');
  print("Density:" + densityRatio.toString());
  canvas.width = width ;
  canvas.height = height;//+16;
//  canvas.style = "width:"+html.window.screen.available.width +",height:"+html.window.screen.available.height+",";
//  canvas.style.height = 
  
//  canvas.width = html.window.screen.available.width;
//  canvas.height = html.window.screen.available.height;
  
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
  resourceManager.addTextureAtlas("sardineNets", "images/sardineNet.json", TextureAtlasFormat.JSONARRAY);
  resourceManager.addTextureAtlas("tunaNets", "images/tunaNet.json", TextureAtlasFormat.JSONARRAY);
  resourceManager.addTextureAtlas("sharkNets", "images/sharkNet.json", TextureAtlasFormat.JSONARRAY);
  resourceManager.addTextureAtlas("sardineNetsSmall", "images/sardineNetSmall.json", TextureAtlasFormat.JSONARRAY);
  resourceManager.addTextureAtlas("tunaNetsSmall", "images/tunaNetSmall.json", TextureAtlasFormat.JSONARRAY);
  resourceManager.addTextureAtlas("sharkNetsSmall", "images/sharkNetSmall.json", TextureAtlasFormat.JSONARRAY);
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
  resourceManager.addBitmapData("CapacityUpgradeButtonSmall", "images/capUpgradeIcon.png");
  resourceManager.addBitmapData("CapacityUpgradeButtonLarge", "images/capUpgradeIconBig.png");
  
  resourceManager.addBitmapData("SardineBoatButtonGlow", "images/sardineBoatIconGlow.png");
  resourceManager.addBitmapData("TunaBoatButtonGlow", "images/tunaBoatIconGlow.png");
  resourceManager.addBitmapData("SharkBoatButtonGlow", "images/sharkBoatIconGlow.png");
  resourceManager.addBitmapData("CapacityUpgradeButtonSmallGlow", "images/capUpgradeIconGlow.png");
  resourceManager.addBitmapData("CapacityUpgradeButtonLargeGlow", "images/capUpgradeIconBigGlow.png");
  
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
  resourceManager.addBitmapData("endgameWinIcon", "images/endgameWinIcon.png");
  resourceManager.addBitmapData("endgameSardineIcon", "images/endgameSardineIcon.png");
  resourceManager.addBitmapData("endgameTunaIcon", "images/endgameTunaIcon.png");
  resourceManager.addBitmapData("endgameSharkIcon", "images/endgameSharkIcon.png");
  resourceManager.addBitmapData("sellIsland", "images/sell_island.png");
  resourceManager.addBitmapData("ecosystemScore0", "images/ecosystemScore0.png");
  resourceManager.addBitmapData("ecosystemScore1", "images/ecosystemScore1.png");
  resourceManager.addBitmapData("ecosystemScore2", "images/ecosystemScore2.png");
  resourceManager.addBitmapData("ecosystemScore3", "images/ecosystemScore3.png");
  resourceManager.addBitmapData("ecosystemScore4", "images/ecosystemScore4.png");
  resourceManager.addBitmapData("ecosystemScore5", "images/ecosystemScore5.png");
  resourceManager.addBitmapData("ecosystemScore6", "images/ecosystemScore6.png");
  resourceManager.addBitmapData("ecosystemScore7", "images/ecosystemScore7.png");
  resourceManager.addBitmapData("ecosystemScore8", "images/ecosystemScore8.png");
  resourceManager.addBitmapData("ecosystemScore9", "images/ecosystemScore9.png");
  resourceManager.addBitmapData("ecosystemScore10", "images/ecosystemScore10.png");
  resourceManager.addBitmapData("ecosystemScore11", "images/ecosystemScore11.png");
  resourceManager.addBitmapData("ecosystemScore12", "images/ecosystemScore12.png");
  resourceManager.addBitmapData("ecosystemScore13", "images/ecosystemScore13.png");
  resourceManager.addBitmapData("ecosystemScore14", "images/ecosystemScore14.png");
  resourceManager.addBitmapData("ecosystemScore15", "images/ecosystemScore15.png");
  resourceManager.addBitmapData("replayButton", "images/replayButton.png");
  resourceManager.addBitmapData("timerGlow", "images/timerGlow.png");

  resourceManager.addBitmapData("teamAScoreCircle", "images/teamAScoreCircle.png");
  resourceManager.addBitmapData("teamBScoreCircle", "images/teamBScoreCircle.png");
  resourceManager.addBitmapData("title", "images/title.png");
  resourceManager.addBitmapData("about", "images/about.png");
  resourceManager.addBitmapData("playButton", "images/playButton.png");
  resourceManager.addBitmapData("playButtonPressed", "images/playButtonPressed.png");
  resourceManager.addBitmapData("aboutButton", "images/aboutButton.png");
  resourceManager.addBitmapData("aboutButtonPressed", "images/aboutButtonPressed.png");
  
  resourceManager.addSound("buttonClick", "sounds/button_click.mp3");
  resourceManager.addSound("circleUISwoosh", "sounds/circle_swoosh.mp3");
  resourceManager.addSound("chaChing", "sounds/cha_ching.mp3");
  resourceManager.addSound("buySplash", "sounds/buy_splash.mp3");
  resourceManager.addSound("itemSuction", "sounds/item_suction.mp3");
  resourceManager.addSound("timerSound", "sounds/round_timer.mp3");
//  resourceManager.addSound("badgeSound", "sounds/badge_sound.mp3");
//  resourceManager.addSound("starSound", "sounds/star_sound.mp3");
  
  resourceManager.addSound("sardineCatchSound01", "sounds/sardineCatchSound01.mp3");
  resourceManager.addSound("sardineCatchSound02", "sounds/sardineCatchSound02.mp3");
  resourceManager.addSound("sardineCatchSound03", "sounds/sardineCatchSound03.mp3");
  resourceManager.addSound("sardineCatchSound04", "sounds/sardineCatchSound04.mp3");
  resourceManager.addSound("sardineCatchSound05", "sounds/sardineCatchSound05.mp3");
  
//  resourceManager.addSound("sardineCatchSound01", "sounds/sardineCatchSound01.wav");
//  resourceManager.addSound("sardineCatchSound02", "sounds/sardineCatchSound02.wav");
//  resourceManager.addSound("sardineCatchSound03", "sounds/sardineCatchSound03.wav");
//  resourceManager.addSound("sardineCatchSound04", "sounds/sardineCatchSound04.wav");
//  resourceManager.addSound("sardineCatchSound05", "sounds/sardineCatchSound05.wav");
  
  resourceManager.addSound("tunaCatchSound01", "sounds/tunaCatchSound01.mp3");
  resourceManager.addSound("tunaCatchSound02", "sounds/tunaCatchSound02.mp3");
  resourceManager.addSound("tunaCatchSound03", "sounds/tunaCatchSound03.mp3");
  resourceManager.addSound("tunaCatchSound04", "sounds/tunaCatchSound04.mp3");
  resourceManager.addSound("tunaCatchSound05", "sounds/tunaCatchSound05.mp3");
  
  resourceManager.addSound("sharkCatchSound01", "sounds/sharkCatchSound01.mp3");
  resourceManager.addSound("sharkCatchSound02", "sounds/sharkCatchSound02.mp3");
  resourceManager.addSound("sharkCatchSound03", "sounds/sharkCatchSound03.mp3");
  resourceManager.addSound("sharkCatchSound04", "sounds/sharkCatchSound04.mp3");
  resourceManager.addSound("sharkCatchSound05", "sounds/sharkCatchSound05.mp3");
  
  resourceManager.addSound("starSound01", "sounds/starSound01.mp3");
  resourceManager.addSound("starSound02", "sounds/starSound02.mp3");
  resourceManager.addSound("starSound03", "sounds/starSound03.mp3");
  
  resourceManager.addSound("badgeSoundOverpopulated", "sounds/badgeSoundOverpopulated.mp3");
  resourceManager.addSound("badgeSoundLeastConcern", "sounds/badgeSoundLeastConcern.mp3");
  resourceManager.addSound("badgeSoundEndangered", "sounds/badgeSoundEndangered.mp3");
  resourceManager.addSound("badgeSoundExtinct", "sounds/badgeSoundExtinct.mp3");
  
  resourceManager.addSound("ui_playButton", "sounds/ui_playButton.mp3");
  resourceManager.addSound("ui_aboutButtonOpen", "sounds/ui_aboutButtonOpen.mp3");
  resourceManager.addSound("ui_aboutButtonClose", "sounds/ui_aboutButtonClose.mp3");
  
  resourceManager.addSound("ui_tapTimer", "sounds/ui_tapTimer.mp3");
  
  resourceManager.addSound("ui_selectSardineBoat", "sounds/ui_selectSardineBoat.mp3");
  resourceManager.addSound("ui_selectTunaBoat", "sounds/ui_selectTunaBoat.mp3");
  resourceManager.addSound("ui_selectSharkBoat", "sounds/ui_selectSharkBoat.mp3");
  resourceManager.addSound("ui_selectSmallNet", "sounds/ui_selectSmallNet.mp3");
  resourceManager.addSound("ui_selectBigNet", "sounds/ui_selectBigNet.mp3");
  resourceManager.addSound("ui_rotateBuyDisc", "sounds/ui_rotateBuyDisc.mp3");
  
  resourceManager.addSound("ui_restartGame", "sounds/ui_restartGame.mp3");
  
  resourceManager.addSound("transition_titleToFishing", "sounds/transition_titleToFishing.mp3");
  resourceManager.addSound("transition_fishingToRegrowth", "sounds/transition_fishingToRegrowth.mp3");
  resourceManager.addSound("transition_regrowthToBuy", "sounds/transition_regrowthToBuy.mp3");
  resourceManager.addSound("transition_buyToFishing", "sounds/transition_buyToFishing.mp3");
  resourceManager.addSound("transition_regrowthToEnd", "sounds/transition_regrowthToEnd.mp3");
  resourceManager.addSound("transition_endToSummary", "sounds/transition_endToSummary.mp3");
  resourceManager.addSound("boatFull", "boatFull.mp3");
  
  
  Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
  
  print("Inner Width" + html.window.innerWidth.toString());
  print("Inner height" + html.window.innerHeight.toString());
  print("Screen width" + html.window.screen.available.width.toString());
  print("Screen Height" + html.window.screen.available.height.toString());
  
  resourceManager.load().then((res) {
    var game = new Game(resourceManager, stage.juggler, width, height);
    stage.addChild(game);
    stage.juggler.add(game);
    var canvas = html.querySelector('#stage');
    print("Density:" + densityRatio.toString());
    canvas.width = width ;
    canvas.height = height;//+16;
//    var screenWidth = html.window.screen.available.width;
    canvas.style.width = html.window.innerWidth.toString()+"px";
    canvas.style.height = html.window.innerHeight.toString()+"px";
  });
  
//  initWebSocket();
}