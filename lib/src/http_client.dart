import 'dart:convert';
import 'package:dahttp/src/http_interceptor.dart';
import 'package:dahttp/src/http_logger.dart';
import 'package:dahttp/src/http_result.dart';
import 'package:http/http.dart';

abstract class ValueHttp<T> {
  final HttpInterceptor interceptor;
  final HttpLogger logger;

  ValueHttp({this.interceptor, HttpLogger logger})
      : logger = logger ?? EmptyHttpLogger();

  T convert(Response response);

  Future<HttpResult<T>> head(String url, {Map<String, String> headers}) async {
    final _CustomClient client = _client();

    return _execute(client, client.head(url, headers: headers));
  }

  Future<HttpResult<T>> get(String url, {Map<String, String> headers}) async {
    final _CustomClient client = _client();

    return _execute(client, client.get(url, headers: headers));
  }

  Future<HttpResult<T>> post(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    final _CustomClient client = _client();

    return _execute(client,
        client.post(url, headers: headers, body: body, encoding: encoding));
  }

  Future<HttpResult<T>> put(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    final _CustomClient client = _client();

    return _execute(client,
        client.put(url, headers: headers, body: body, encoding: encoding));
  }

  Future<HttpResult<T>> patch(String url,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    final _CustomClient client = _client();

    return _execute(client,
        client.patch(url, headers: headers, body: body, encoding: encoding));
  }

  Future<HttpResult<T>> delete(String url,
      {Map<String, String> headers}) async {
    final _CustomClient client = _client();

    return _execute(client, client.delete(url, headers: headers));
  }

  Future<HttpResult<T>> _execute(
      _CustomClient client, Future<Response> futureResponse) async {
    try {
      Response response = await futureResponse;
      response =
          (interceptor != null) ? interceptor.response(response) : response;
      logger.response(response);

      return HttpResult<T>.result(response, _data(response));
    } catch (e) {
      return HttpResult<T>.exception(e);
    } finally {
      client.close();
    }
  }

  _CustomClient _client() => _CustomClient(interceptor, logger);

  T _data(Response response) {
    return ((response != null) &&
            (response.statusCode >= 200) &&
            (response.statusCode <= 299))
        ? convert(response)
        : null;
  }
}

class EmptyHttp extends ValueHttp<void> {
  EmptyHttp({HttpInterceptor interceptor, HttpLogger logger})
      : super(interceptor: interceptor, logger: logger);

  @override
  void convert(Response response) {}
}

class _CustomClient extends BaseClient {
  final Client _client = Client();
  final HttpInterceptor _interceptor;
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
