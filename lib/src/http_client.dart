import 'dart:convert';
import 'package:dahttp/src/http_logger.dart';
import 'package:dahttp/src/http_result.dart';
import 'package:http/http.dart';

abstract class ValuedHttpClient<T> {
  final HttpLogger logger;

  ValuedHttpClient({HttpLogger logger}) : logger = logger ?? EmptyHttpLogger();

  T convert(Response response);

  Future<HttpResult<T>> head(String url,
      {Map<String, dynamic> query, Map<String, String> headers}) async {
    final _CustomClient client = _client();

    return _process(client, client.head(_url(url, query), headers: headers));
  }

  Future<HttpResult<T>> get(String url,
      {Map<String, dynamic> query, Map<String, String> headers}) async {
    final _CustomClient client = _client();

    return _process(client, client.get(_url(url, query), headers: headers));
  }

  Future<HttpResult<T>> post(String url,
      {Map<String, dynamic> query,
      Map<String, String> headers,
      dynamic body,
      Encoding encoding}) async {
    final _CustomClient client = _client();

    return _process(
        client,
        client.post(_url(url, query),
            headers: headers, body: body, encoding: encoding));
  }

  Future<HttpResult<T>> put(String url,
      {Map<String, dynamic> query,
      Map<String, String> headers,
      dynamic body,
      Encoding encoding}) async {
    final _CustomClient client = _client();

    return _process(
        client,
        client.put(_url(url, query),
            headers: headers, body: body, encoding: encoding));
  }

  Future<HttpResult<T>> patch(String url,
      {Map<String, dynamic> query,
      Map<String, String> headers,
      dynamic body,
      Encoding encoding}) async {
    final _CustomClient client = _client();

    return _process(
        client,
        client.patch(_url(url, query),
            headers: headers, body: body, encoding: encoding));
  }

  Future<HttpResult<T>> delete(String url,
      {Map<String, dynamic> query, Map<String, String> headers}) async {
    final _CustomClient client = _client();

    return _process(client, client.delete(_url(url, query), headers: headers));
  }

  Future<HttpResult<T>> _process(
      _CustomClient client, Future<Response> futureResponse) async {
    try {
      final Response response = await futureResponse;
      logger.response(response);

      return HttpResult<T>.result(response, _data(response));
    } catch (e) {
      return HttpResult<T>.exception(e);
    } finally {
      client.close();
    }
  }

  _CustomClient _client() => _CustomClient(logger);

  String _url(String baseUrl, Map<String, dynamic> queryParameters) {
    String query = '';

    if (queryParameters != null) {
      for (String key in queryParameters.keys) {
        if (query.isEmpty) {
          query += '?';
        } else {
          query += '&';
        }

        query += '$key=${queryParameters[key]}';
      }
    }

    return '$baseUrl$query';
  }

  T _data(Response response) {
    return ((response != null) &&
            (response.statusCode >= 200) &&
            (response.statusCode <= 299))
        ? _convert(response)
        : null;
  }

  T _convert(Response response) {
    try {
      return convert(response);
    } catch (e) {
      throw FormatException(
          'Errror converting response to $T. Content:\n${response.body}', e);
    }
  }
}

class EmptyHttpClient extends ValuedHttpClient<void> {
  EmptyHttpClient({HttpLogger logger}) : super(logger: logger);

  @override
  void convert(Response response) {}
}

class _CustomClient extends BaseClient {
  final Client _client = Client();
  final HttpLogger _logger;

  _CustomClient(this._logger);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    _logger.request(request);

    return _client.send(request);
  }

  @override
  void close() => _client.close();
}
