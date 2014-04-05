library TOTC;

import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:async';
import 'dart:io';
import 'package:route/server.dart';
import 'source/util.dart' show serveFile;

import 'package:stagexl/stagexl.dart';

part 'source/game.dart';
part 'source/touch.dart';
part 'source/fleet.dart';
part 'source/boat.dart';
part 'source/net.dart';
part 'source/ecosystem.dart';
part 'source/fish.dart';
part 'source/movement.dart';

void main() {
  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 9999 : int.parse(portEnv);

  HttpServer.bind(InternetAddress.ANY_IP_V4, port).then((HttpServer server) {
    print("Listening on address ${server.address.address}:${port}" );
    String baseDir = "";
    new Directory('build').exists().then((exists) {
      if(exists) {
        new Router(server)
          ..serve('/').listen(serveFile('build/rpghelper.html'))
          ..serve('/rpghelper.css').listen(serveFile('build/rpghelper.css'))
          ..serve('/packages/shadow_dom/shadow_dom.debug.js').listen(serveFile('build/packages/shadow_dom/shadow_dom.debug.js'))
          ..serve('/packages/custom_element/custom-elements.debug.js').listen(serveFile('build/packages/custom_element/custom-elements.debug.js'))
          ..serve('/packages/browser/interop.js').listen(serveFile('build/packages/browser/interop.js'))
          ..serve('/rpghelper.html_bootstrap.dart.js').listen(serveFile('build/rpghelper.html_bootstrap.dart.js'))
          ;
      } else {
        new Router(server)
        ..serve('/').listen((request) {
          request.response
            ..write("Something went wrong, as the build directory can't be found")
            ..close();
        });
      }
    });
  });
  
  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var resourceManager = new ResourceManager();
  resourceManager.addBitmapData("BoatDown", "images/boat_down.png");
  resourceManager.addBitmapData("BoatUp", "images/boat_up.png");
  resourceManager.addBitmapData("Net", "images/net.png");
  resourceManager.addBitmapData("Background", "images/background.png");
  resourceManager.addBitmapData("Mask", "images/mask.png");
  resourceManager.addBitmapData("Tuna", "images/tuna.png");
  resourceManager.addBitmapData("Shark", "images/shark.png");
  resourceManager.addBitmapData("Sardine", "images/sardine.png");
  
  resourceManager.load().then((res) {
    var game = new Game(resourceManager, stage.juggler);
    stage.addChild(game);
  });
}