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

  BaseRequest get request => (_response != null) ? _response.request : null;

  Response get response => _response;

  T get data => _data;

  dynamic get exception => _exception;

  bool hasStatus(int code) => status == code;

  bool get hasData => _data != null;

  bool get hasException => _exception != null;

  int get status => (_response != null) ? _response.statusCode : 0;

  String get body => (_response != null) ? _response.body : '';

  Map<String, String> get headers =>
      (_response != null) ? _response.headers : <String, String>{};

  bool get success => (status >= 200) && (status <= 299);

  bool get error => status >= 400;

  bool get statusOk => hasStatus(HttpStatus.ok);

  bool get statusCreated => hasStatus(HttpStatus.created);

  bool get statusAccepted => hasStatus(HttpStatus.accepted);

  bool get statusNoContent => hasStatus(HttpStatus.noContent);

  bool get statusBadRequest => hasStatus(HttpStatus.badRequest);

  bool get statusUnauthorized => hasStatus(HttpStatus.unauthorized);

  bool get statusForbidden => hasStatus(HttpStatus.forbidden);

  bool get statusNotFound => hasStatus(HttpStatus.notFound);

  bool get statusMethodNotAllowed => hasStatus(HttpStatus.methodNotAllowed);

  bool get statusNotAcceptable => hasStatus(HttpStatus.notAcceptable);

  bool get statusRequestTimeout => hasStatus(HttpStatus.requestTimeout);

  bool get statusConflict => hasStatus(HttpStatus.conflict);

  bool get statusGone => hasStatus(HttpStatus.gone);

  bool get statusLengthRequired => hasStatus(HttpStatus.lengthRequired);

  bool get statusPreconditionFailed => hasStatus(HttpStatus.preconditionFailed);

  bool get statusRequestEntityTooLarge =>
      hasStatus(HttpStatus.requestEntityTooLarge);

  bool get statusUnsupportedMediaType =>
      hasStatus(HttpStatus.unsupportedMediaType);

  bool get statusExpectationFailed => hasStatus(HttpStatus.expectationFailed);

  bool get statusLocked => hasStatus(HttpStatus.locked);

  bool get statusFailedDependency => hasStatus(HttpStatus.failedDependency);

  bool get statusPreconditionRequired =>
      hasStatus(HttpStatus.preconditionRequired);

  bool get statusTooManyRequests => hasStatus(HttpStatus.tooManyRequests);

  bool get statusInternalServerError =>
      hasStatus(HttpStatus.internalServerError);

  bool get statusNotImplemented => hasStatus(HttpStatus.notImplemented);

  bool get statusBadGateway => hasStatus(HttpStatus.badGateway);

  bool get statusServiceUnavailable => hasStatus(HttpStatus.serviceUnavailable);

  bool get statusGatewayTimeout => hasStatus(HttpStatus.gatewayTimeout);

  bool get statusInternetConnection =>
      hasException && (exception is SocketException);

  void handle({
    OnSuccess<T> onSuccess,
    OnError onError,
    OnException onException,
    OnFailure onFailure,
  }) {
    if (success) {
      onSuccess?.call(_data, _response);
    } else if (error && (onError != null)) {
      onError(_response);
    } else if (hasException && (onException != null)) {
      onException(_exception);
    } else {
      onFailure?.call(_response, _exception);
    }
  }

  void handleEmpty({
    OnSuccessEmpty onSuccess,
    OnError onError,
    OnException onException,
    OnFailure onFailure,
  }) {
    if (success) {
      onSuccess?.call(_response);
    } else if (error && (onError != null)) {
      onError(_response);
    } else if (hasException && (onException != null)) {
      onException(_exception);
    } else {
      onFailure?.call(_response, _exception);
    }
  }

  HttpResult<T> onSuccess(OnSuccess<T> onSuccess) {
    if (success) {
      onSuccess?.call(_data, _response);
    }

    return this;
  }

  HttpResult<T> onSuccessEmpty(OnSuccessEmpty onSuccess) {
    if (success) {
      onSuccess?.call(_response);
    }

    return this;
  }

  HttpResult<T> onError(OnError onError) {
    if (error) {
      onError?.call(_response);
    }

    return this;
  }

  HttpResult<T> onException(OnException onException) {
    if (hasException) {
      onException?.call(_exception);
    }

    return this;
  }

  HttpResult<T> onFailure(OnFailure onFailure) {
    if (error || hasException) {
      onFailure?.call(_response, _exception);
    }

    return this;
  }
}

typedef OnSuccess<T> = void Function(T data, Response response);

typedef OnSuccessEmpty = void Function(Response response);

typedef OnError = void Function(Response response);

typedef OnException = void Function(dynamic exception);

typedef OnFailure = void Function(Response response, dynamic exception);
