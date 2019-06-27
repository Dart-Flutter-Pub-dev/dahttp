import 'dart:convert';
import 'package:dahttp/src/http_logger.dart';
import 'package:dahttp/src/http_result.dart';
import 'package:http/http.dart';

abstract class ValueHttp<T> {
  final HttpLogger logger;

  ValueHttp({this.logger});

  T convert(Response response);

  Future<HttpResult<T>> head(url, {Map<String, String> headers}) async {
    final client = _CustomClient(logger);

    try {
      final response = await client.head(url, headers: headers);
      logger?.response(response);

      return HttpResult<T>(response: response, data: convert(response));
    } catch (e) {
      return HttpResult<T>(exception: e);
    } finally {
      client.close();
    }
  }

  Future<HttpResult<T>> get(url, {Map<String, String> headers}) async {
    final client = _CustomClient(logger);

    try {
      final response = await client.get(url, headers: headers);
      logger?.response(response);

      return HttpResult<T>(response: response, data: convert(response));
    } catch (e) {
      return HttpResult<T>(exception: e);
    } finally {
      client.close();
    }
  }

  Future<HttpResult<T>> post(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    final client = _CustomClient(logger);

    try {
      final response = await client.post(url,
          headers: headers, body: body, encoding: encoding);
      logger?.response(response);

      return HttpResult<T>(response: response, data: convert(response));
    } catch (e) {
      return HttpResult<T>(exception: e);
    } finally {
      client.close();
    }
  }

  Future<HttpResult<T>> put(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    final client = _CustomClient(logger);

    try {
      final response = await client.put(url,
          headers: headers, body: body, encoding: encoding);
      logger?.response(response);

      return HttpResult<T>(response: response, data: convert(response));
    } catch (e) {
      return HttpResult<T>(exception: e);
    } finally {
      client.close();
    }
  }

  Future<HttpResult<T>> patch(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    final client = _CustomClient(logger);

    try {
      final response = await client.patch(url,
          headers: headers, body: body, encoding: encoding);
      logger?.response(response);

      return HttpResult<T>(response: response, data: convert(response));
    } catch (e) {
      return HttpResult<T>(exception: e);
    } finally {
      client.close();
    }
  }

  Future<HttpResult<T>> delete(url, {Map<String, String> headers}) async {
    final client = _CustomClient(logger);

    try {
      final response = await client.delete(url, headers: headers);
      logger?.response(response);

      return HttpResult<T>(response: response, data: convert(response));
    } catch (e) {
      return HttpResult<T>(exception: e);
    } finally {
      client.close();
    }
  }
}

class EmptyHttp extends ValueHttp<void> {
  EmptyHttp({HttpLogger logger}) : super(logger: logger);

  @override
  void convert(Response response) {}
}

class _CustomClient extends BaseClient {
  final Client _client = Client();
  final HttpLogger _logger;

  _CustomClient(this._logger);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    _logger?.request(request);
    return _client.send(request);
  }

  @override
  void close() => _client.close();
}
