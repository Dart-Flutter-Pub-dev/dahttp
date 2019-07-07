import 'dart:convert';
import 'package:dahttp/src/http_logger.dart';
import 'package:dahttp/src/http_result.dart';
import 'package:http/http.dart';

abstract class ValueHttp<T> {
  final Interceptor interceptor;
  final HttpLogger logger;

  ValueHttp({this.interceptor, HttpLogger logger})
      : logger = logger ?? EmptyHttpLogger();

  T convert(Response response);

  Future<HttpResult<T>> head(String url, {Map<String, String> headers}) async {
    final _CustomClient client = _CustomClient(interceptor, logger);

    try {
      final Response response =
          _interceptAndLog(await client.head(url, headers: headers));

      return HttpResult<T>.result(response, _data(response));
    } catch (e) {
      return HttpResult<T>.exception(e);
    } finally {
      client.close();
    }
  }

  Future<HttpResult<T>> get(String url, {Map<String, String> headers}) async {
    final _CustomClient client = _CustomClient(interceptor, logger);

    try {
      final Response response =
          _interceptAndLog(await client.get(url, headers: headers));

      return HttpResult<T>.result(response, _data(response));
    } catch (e) {
      return HttpResult<T>.exception(e);
    } finally {
      client.close();
    }
  }

  Future<HttpResult<T>> post(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    final _CustomClient client = _CustomClient(interceptor, logger);

    try {
      final Response response = _interceptAndLog(await client.post(url,
          headers: headers, body: body, encoding: encoding));

      return HttpResult<T>.result(response, _data(response));
    } catch (e) {
      return HttpResult<T>.exception(e);
    } finally {
      client.close();
    }
  }

  Future<HttpResult<T>> put(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    final _CustomClient client = _CustomClient(interceptor, logger);

    try {
      final Response response = _interceptAndLog(await client.put(url,
          headers: headers, body: body, encoding: encoding));

      return HttpResult<T>.result(response, _data(response));
    } catch (e) {
      return HttpResult<T>.exception(e);
    } finally {
      client.close();
    }
  }

  Future<HttpResult<T>> patch(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    final _CustomClient client = _CustomClient(interceptor, logger);

    try {
      final Response response = _interceptAndLog(await client.patch(url,
          headers: headers, body: body, encoding: encoding));

      return HttpResult<T>.result(response, _data(response));
    } catch (e) {
      return HttpResult<T>.exception(e);
    } finally {
      client.close();
    }
  }

  Future<HttpResult<T>> delete(String url,
      {Map<String, String> headers}) async {
    final _CustomClient client = _CustomClient(interceptor, logger);

    try {
      final Response response =
          _interceptAndLog(await client.delete(url, headers: headers));

      return HttpResult<T>.result(response, _data(response));
    } catch (e) {
      return HttpResult<T>.exception(e);
    } finally {
      client.close();
    }
  }

  Response _interceptAndLog(Response response) {
    final Response finalResponse =
        (interceptor != null) ? interceptor.response(response) : response;
    logger.response(finalResponse);

    return finalResponse;
  }

  T _data(Response response) {
    return ((response != null) &&
            (response.statusCode >= 200) &&
            (response.statusCode <= 299))
        ? convert(response)
        : null;
  }
}

class EmptyHttp extends ValueHttp<void> {
  EmptyHttp({Interceptor interceptor, HttpLogger logger})
      : super(interceptor: interceptor, logger: logger);

  @override
  void convert(Response response) {}
}

class _CustomClient extends BaseClient {
  final Client _client = Client();
  final Interceptor _interceptor;
  final HttpLogger _logger;

  _CustomClient(this._interceptor, this._logger);

  @override
  Future<StreamedResponse> send(BaseRequest baseRequest) {
    final BaseRequest request = (_interceptor != null)
        ? _interceptor.request(baseRequest)
        : baseRequest;
    _logger.request(request);
    return _client.send(request);
  }

  @override
  void close() => _client.close();
}

abstract class Interceptor {
  BaseRequest request(BaseRequest request);

  BaseResponse response(Response response);
}
