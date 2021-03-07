import 'package:http/http.dart';

class DefaultHttpLogger extends HttpLogger {
  final bool headers;
  final bool body;
  late DateTime start;
  late String tag;

  DefaultHttpLogger({this.headers = true, this.body = true});

  @override
  void request(Request request) {
    start = DateTime.now();
    tag = (1000 + start.microsecond).toString();

    print(
        '--> ${request.method} ${request.url} (${request.contentLength}-byte body) [$tag]');

    if (headers) {
      final Map<String, String> headers = request.headers;

      for (final String header in headers.keys) {
        print('$header: ${headers[header]}');
      }
    }

    if (body && request.body.isNotEmpty) {
      print(request.body);
    }

    print('--> END [$tag]');
  }

  @override
  void response(Response response) {
    final Duration difference = DateTime.now().difference(start);
    print(
        '<-- ${response.statusCode} ${response.reasonPhrase} (${difference.inMilliseconds}ms) [$tag]');

    if (headers) {
      final Map<String, String> headers = response.headers;

      for (final String header in headers.keys) {
        print('$header: ${headers[header]}');
      }
    }

    if (body && response.body.isNotEmpty) {
      print(response.body);
    }

    print('<-- END [$tag]');
  }

  @override
  void exception(dynamic exception) => print(exception);
}

class EmptyHttpLogger extends HttpLogger {
  const EmptyHttpLogger();

  @override
  void request(Request request) {}

  @override
  void response(Response response) {}

  @override
  void exception(dynamic exception) {}
}

abstract class HttpLogger {
  const HttpLogger();

  void request(Request request);

  void response(Response response);

  void exception(dynamic exception);
}
