import 'package:http/http.dart';

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
