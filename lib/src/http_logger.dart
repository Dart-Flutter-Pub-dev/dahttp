import 'package:http/http.dart';

class DefaultHttpLogger extends HttpLogger {
  final bool headers;
  final bool body;
  DateTime start;
  String tag;

  DefaultHttpLogger({this.headers, this.body});

  @override
  void request(Request request) {
    start = DateTime.now();
    tag = (1000 + start.microsecond).toString();

    print(
        '--> ${request.method} ${request.url} (${request.contentLength}-byte body) [$tag]');

    if ((headers != null) && headers) {
      final Map<String, String> headers = request.headers;

      for (String header in headers.keys) {
        print('$header: ${headers[header]}');
      }
    }

    if ((body != null) && body && request.body.isNotEmpty) {
      print(request.body);
    }

    print('--> END [$tag]');
  }

  @override
  void response(Response response) {
    final Duration difference = DateTime.now().difference(start);
    print(
        '<-- ${response.statusCode} ${response.reasonPhrase} (${difference.inMilliseconds}ms) [$tag]');

    if ((headers != null) && headers) {
      final Map<String, String> headers = response.headers;

      for (String header in headers.keys) {
        print('$header: ${headers[header]}');
      }
    }

    if ((body != null) && body && response.body.isNotEmpty) {
      print(response.body);
    }

    print('<-- END [$tag]');
  }

  @override
  void exception(dynamic exception) => print(exception);
}

class EmptyHttpLogger extends HttpLogger {
  @override
  void request(Request request) {}

  @override
  void response(Response response) {}

  @override
  void exception(dynamic exception) {}
}

abstract class HttpLogger {
  void request(Request request);

  void response(Response response);

  void exception(dynamic exception);
}
