import 'dart:io';
import 'package:mime/mime.dart';

Function serveFile(String filename) {
  String mimeType = lookupMimeType(filename);

  String type = "text";
  String subType = "plain";

  if(mimeType != null) {
    type = mimeType.split("/")[0];
    subType = mimeType.split("/")[1];
  }
  return (HttpRequest request) {
    request.response.headers.contentType = new ContentType(type, subType);
    new File(filename).openRead().pipe(request.response).then((val){

    });
  };
}