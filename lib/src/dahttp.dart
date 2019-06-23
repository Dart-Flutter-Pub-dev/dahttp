import 'dart:convert';
import 'package:dahttp/src/http_logger.dart';
import 'package:http/http.dart';

abstract class ValueHttp<T> {
  final HttpLogger logger;

  ValueHttp({HttpLogger logger})
      : logger = (logger != null) ? logger : DefaultHttpLogger(true);

  T convert(Response response);

  Future<HttpResult<T>> get(url, {Map<String, String> headers}) async {
    var client = CustomClient(logger);

    try {
      var response = await client.get(url, headers: headers);
      logger.response(response);

      return HttpResult<T>(response: response, value: convert(response));
    } catch (e) {
      return HttpResult<T>(exception: e);
    } finally {
      client.close();
    }
  }

  Future<HttpResult<T>> post(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    var client = CustomClient(logger);

    try {
      var response = await client.post(url,
          headers: headers, body: body, encoding: encoding);
      logger.response(response);

      return HttpResult<T>(response: response, value: convert(response));
    } catch (e) {
      return HttpResult<T>(exception: e);
    } finally {
      client.close();
    }
  }

  Future<HttpResult<T>> put(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    var client = CustomClient(logger);

    try {
      var response = await client.put(url,
          headers: headers, body: body, encoding: encoding);
      logger.response(response);

      return HttpResult<T>(response: response, value: convert(response));
    } catch (e) {
      return HttpResult<T>(exception: e);
    } finally {
      client.close();
    }
  }

  Future<HttpResult<T>> patch(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    var client = CustomClient(logger);

    try {
      var response = await client.patch(url,
          headers: headers, body: body, encoding: encoding);
      logger.response(response);

      return HttpResult<T>(response: response, value: convert(response));
    } catch (e) {
      return HttpResult<T>(exception: e);
    } finally {
      client.close();
    }
  }

  Future<HttpResult<T>> delete(url, {Map<String, String> headers}) async {
    var client = CustomClient(logger);

    try {
      var response = await client.delete(url, headers: headers);
      logger.response(response);

      return HttpResult<T>(response: response, value: convert(response));
    } catch (e) {
      return HttpResult<T>(exception: e);
    } finally {
      client.close();
    }
  }
}

class EmptyHttp extends ValueHttp<Null> {
  EmptyHttp({HttpLogger logger}) : super(logger: logger);

  @override
  Null convert(Response response) {
    return null;
  }
}

class CustomClient extends BaseClient {
  final Client _client = Client();
  final DefaultHttpLogger _logger;

  CustomClient(this._logger);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    _logger.request(request);
    return _client.send(request);
  }

  @override
  void close() => _client.close();
}

class HttpResult<T> {
  final Response response;
  final T value;
  final dynamic exception;

  HttpResult({this.response, this.value, this.exception});

  bool get isSuccessful =>
      (response != null) &&
      (response.statusCode >= 200) &&
      (response.statusCode <= 299);

  bool get isUnsuccessful => (response != null) && (response.statusCode >= 400);

  bool get hasFailed => (exception != null);
}
