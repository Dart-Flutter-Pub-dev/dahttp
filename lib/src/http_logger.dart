import 'dart:math';
import 'package:http/http.dart';

class DefaultHttpLogger extends HttpLogger {
  final bool enabled;
  DateTime start;
  String tag;

  DefaultHttpLogger(this.enabled);

  @override
  void request(Request request) {
    if (enabled) {
      start = DateTime.now();
      tag = (1000 + Random().nextInt(9999 - 1000)).toString();

      print(
          '--> ${request.method} ${request.url} (${request.contentLength}-byte body) [$tag]');

      final headers = request.headers;

      for (var header in headers.keys) {
        print('$header: ${headers[header]}');
      }

      if (request.body.isNotEmpty) {
        print(request.body);
      }

      print('--> END [$tag]');
    }
  }

  @override
  void response(Response response) {
    if (enabled) {
      final difference = DateTime.now().difference(start);
      print(
          '<-- ${response.statusCode} ${response.reasonPhrase} (${difference.inMilliseconds}ms) [$tag]');

      final headers = response.headers;

      for (var header in headers.keys) {
        print('$header: ${headers[header]}');
      }

      if (response.body.isNotEmpty) {
        print(response.body);
      }

      print('<-- END [$tag]');
    }
  }
}

class EmptyHttpLogger extends HttpLogger {
  @override
  void request(Request request) {}

  @override
  void response(Response response) {}
}

abstract class HttpLogger {
  void request(Request request);

  void response(Response response);
}
