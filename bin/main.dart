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
          ..serve('/').listen(serveFile('web/index.html'))
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