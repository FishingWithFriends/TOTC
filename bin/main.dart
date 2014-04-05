import 'dart:io';
import 'package:route/server.dart';
import 'utils.dart' show serveFile;

main(args) {
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
}