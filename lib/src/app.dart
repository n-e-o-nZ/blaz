import 'dart:io';
import 'package:blaz/blaz.dart';

typedef Handler = Future<void> Function(HttpRequest request);

class App {
  bool localHost;
  int port;
  HttpServer? _server;
  Logger logger = Logger();

  final Map<String, Handler> _routes = {};

  App(this.localHost, this.port);

  Future<void> update() async {
    _server = await HttpServer.bind(
      localHost ? 'localhost' : '0.0.0.0',
      port,
    );
    logger.i('Server running on http://${localHost ? "localhost" : "0.0.0.0"}:$port');
    await for (HttpRequest request in _server!) {
      _handleRequest(request);
    }
  }

  void route(String path, Handler handler) {
    _routes[path] = handler;
  }

  void _handleRequest(HttpRequest request) async {
    final path = request.uri.path;
    if (_routes.containsKey(path)) {
      try {
        await _routes[path]!(request);
      } catch (e) {
        logger.e("Handler Error: $e");
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..write("Internal Server Error")
          ..close();
      }
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write("404: Not Found")
        ..close();
    }
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    logger.w('Server stopped');
  }
}
