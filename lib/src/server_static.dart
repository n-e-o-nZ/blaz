import 'dart:io';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

import 'app.dart';
import 'logger.dart';

class ServerStatic {
  String wwwRootPath;
  String mainFileName;
  Logger logger = Logger();
  List<String> staticFiles = []; 
  App app;

  ServerStatic(this.wwwRootPath, this.mainFileName, this.app);

  Future<void> setUp() async {
    logger.i('Starting file setup...');
    if (await Directory(wwwRootPath).exists()) {
      await for (var entity in Directory(wwwRootPath).list(recursive: true, followLinks: false)) {
        if (entity is File) {
          String relativePath = p.relative(entity.path, from: wwwRootPath);
          staticFiles.add('/$relativePath');
        }
      }
      logger.i('Static files loaded: ${staticFiles.length}');
    } else {
      logger.e('Directory does not exist: $wwwRootPath');
    }
  }

  Future<void> update() async {
    String mainFilePath = p.join(wwwRootPath, mainFileName);
    String? mime = lookupMimeType(mainFilePath);
    if (mime != null) {
      app.route('/', (req) async {
        logger.req(req.uri.path);
        req.response
          ..headers.contentType = ContentType.parse(mime)
          ..write(await File(mainFilePath).readAsString())
          ..close();
      });
    }

    for (String filePath in staticFiles) {
      String currentFile=filePath.substring(1);
      String fullPath = p.join(wwwRootPath, currentFile);
      String? fileMime = lookupMimeType(fullPath); 
      if (fileMime != null) {
        app.route(filePath, (req) async {
          logger.req(req.uri.path);
          req.response
            ..headers.contentType = ContentType.parse(fileMime)
            ..write(await File(fullPath).readAsString()) 
            ..close();
        });
      }
    }
  }
}