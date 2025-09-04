import 'dart:io';
import 'package:blaz/blaz.dart';

typedef Handler = void Function(HttpRequest request);

class App {
  bool localHost;
  int port;
  HttpServer? _server;
  Logger logger = Logger();

  final Map<String, Handler> _routes = {};

  App(this.localHost, this.port);

  Future<void> setUp() async {
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

  void _handleRequest(HttpRequest request) {
    final path = request.uri.path;
    if (_routes.containsKey(path)) {
      _routes[path]!(request);
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write("404: Not Found")
        ..close();
    }
  }

  void stop() {
    _server?.close();
  }
}
