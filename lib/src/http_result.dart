import 'package:http/http.dart';

class HttpResult<T> {
  final Response _response;
  final T _data;
  final dynamic _exception;

  HttpResult.result(this._response, this._data) : _exception = null;

  HttpResult.exception(this._exception)
      : _response = null,
        _data = null;

  Response get response => _response;

  T get data => _data;

  dynamic get exception => _exception;

  bool get isSuccess =>
      (_response != null) &&
      (_response.statusCode >= 200) &&
      (_response.statusCode <= 299);

  bool get isError => (_response != null) && (_response.statusCode >= 400);

  bool get hasException => _exception != null;

  bool get hasData => _data != null;

  String get body => (_response != null) ? _response.body : '';

  Map<String, String> get headers =>
      (_response != null) ? _response.headers : <String, String>{};

  bool hasStatus(int code) =>
      (_response != null) && (_response.statusCode == code);

  void handle({
    OnSuccess<T> success,
    OnError error,
    OnException exception,
    OnFailure failure,
  }) {
    if (isSuccess) {
      success?.call(_data, _response);
    } else if (isError && (error != null)) {
      error(_response);
    } else if (hasException && (exception != null)) {
      exception(_exception);
    } else {
      failure?.call(_response, _exception);
    }
  }

  void handleEmpty({
    OnSuccessEmpty successful,
    OnError error,
    OnException exception,
    OnFailure failure,
  }) {
    if (isSuccess) {
      successful?.call(_response);
    } else if (isError && (error != null)) {
      error(_response);
    } else if (hasException && (exception != null)) {
      exception(_exception);
    } else {
      failure?.call(_response, _exception);
    }
  }

  HttpResult<T> onSuccess(OnSuccess<T> success) {
    if (isSuccess) {
      success?.call(_data, _response);
    }

    return this;
  }

  HttpResult<T> onSuccessEmpty(OnSuccessEmpty success) {
    if (isSuccess) {
      success?.call(_response);
    }

    return this;
  }

  HttpResult<T> onError(OnError error) {
    if (isError) {
      error?.call(_response);
    }

    return this;
  }

  HttpResult<T> onException(OnException exception) {
    if (hasException) {
      exception?.call(_exception);
    }

    return this;
  }

  HttpResult<T> onFailure(OnFailure failure) {
    if (isError || hasException) {
      failure?.call(_response, _exception);
    }

    return this;
  }
}

typedef OnSuccess<T> = void Function(T data, Response response);

typedef OnSuccessEmpty = void Function(Response response);

typedef OnError = void Function(Response response);

typedef OnException = void Function(dynamic exception);

typedef OnFailure = void Function(Response response, dynamic exception);
