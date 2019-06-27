import 'package:http/http.dart';

class HttpResult<T> {
  final Response response;
  final T data;
  final dynamic exception;

  HttpResult({this.response, this.data, this.exception});

  bool get isSuccessful =>
      (response != null) &&
      (response.statusCode >= 200) &&
      (response.statusCode <= 299);

  bool get isUnsuccessful => (response != null) && (response.statusCode >= 400);

  String get body => (response != null) ? response.body : '';

  Map<String, String> get headers =>
      (response != null) ? response.headers : <String, String>{};

  bool status(int code) => (response != null) && (response.statusCode == code);

  bool get hasFailed => exception != null;
}
