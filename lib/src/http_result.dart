import 'dart:io';

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

  bool get isOk => _is(HttpStatus.ok);

  bool get isCreated => _is(HttpStatus.created);

  bool get isAccepted => _is(HttpStatus.accepted);

  bool get isNoContent => _is(HttpStatus.noContent);

  bool get isBadRequest => _is(HttpStatus.badRequest);

  bool get isAnauthorized => _is(HttpStatus.unauthorized);

  bool get isForbidden => _is(HttpStatus.forbidden);

  bool get isNotFound => _is(HttpStatus.notFound);

  bool get isMethodNotAllowed => _is(HttpStatus.methodNotAllowed);

  bool get isNotAcceptable => _is(HttpStatus.notAcceptable);

  bool get isRequestTimeout => _is(HttpStatus.requestTimeout);

  bool get isConflict => _is(HttpStatus.conflict);

  bool get isGone => _is(HttpStatus.gone);

  bool get isLengthRequired => _is(HttpStatus.lengthRequired);

  bool get isPreconditionFailed => _is(HttpStatus.preconditionFailed);

  bool get isRequestEntityTooLarge => _is(HttpStatus.requestEntityTooLarge);

  bool get isUnsupportedMediaType => _is(HttpStatus.unsupportedMediaType);

  bool get isExpectationFailed => _is(HttpStatus.expectationFailed);

  bool get isLocked => _is(HttpStatus.locked);

  bool get isFailedDependency => _is(HttpStatus.failedDependency);

  bool get isPreconditionRequired => _is(HttpStatus.preconditionRequired);

  bool get isTooManyRequests => _is(HttpStatus.tooManyRequests);

  bool get isInternalServerError => _is(HttpStatus.internalServerError);

  bool get isNotImplemented => _is(HttpStatus.notImplemented);

  bool get isBadGateway => _is(HttpStatus.badGateway);

  bool get isServiceUnavailable => _is(HttpStatus.serviceUnavailable);

  bool get isGatewayTimeout => _is(HttpStatus.gatewayTimeout);

  bool hasStatus(int code) => _is(code);

  bool get hasException => _exception != null;

  bool get hasData => _data != null;

  String get body => (_response != null) ? _response.body : '';

  Map<String, String> get headers =>
      (_response != null) ? _response.headers : <String, String>{};

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

  bool _is(int code) => (_response != null) && (_response.statusCode == code);
}

typedef OnSuccess<T> = void Function(T data, Response response);

typedef OnSuccessEmpty = void Function(Response response);

typedef OnError = void Function(Response response);

typedef OnException = void Function(dynamic exception);

typedef OnFailure = void Function(Response response, dynamic exception);
