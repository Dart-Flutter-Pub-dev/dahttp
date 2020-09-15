import 'package:http/http.dart';

class HttpResult<T> {
  final Response _response;
  final T _data;
  final dynamic _exception;

  HttpResult.result(this._response, this._data) : _exception = null;

  HttpResult.exception(this._exception)
      : _response = null,
        _data = null;

  BaseRequest get request => hasResponse ? _response.request : null;

  Response get response => _response;

  T get data => _data;

  dynamic get exception => _exception;

  bool hasStatus(int code) => status == code;

  bool get hasResponse => _response != null;

  bool get hasData => _data != null;

  bool get hasException => _exception != null;

  int get status => hasResponse ? _response.statusCode : 0;

  String get body => hasResponse ? _response.body : '';

  Map<String, String> get headers =>
      hasResponse ? _response.headers : <String, String>{};

  bool get success => (status >= 200) && (status <= 299);

  bool get error => status >= 400;

  bool get statusOk => hasStatus(200);

  bool get statusCreated => hasStatus(201);

  bool get statusAccepted => hasStatus(202);

  bool get statusNoContent => hasStatus(204);

  bool get statusBadRequest => hasStatus(400);

  bool get statusUnauthorized => hasStatus(401);

  bool get statusForbidden => hasStatus(403);

  bool get statusNotFound => hasStatus(404);

  bool get statusMethodNotAllowed => hasStatus(405);

  bool get statusNotAcceptable => hasStatus(406);

  bool get statusRequestTimeout => hasStatus(408);

  bool get statusConflict => hasStatus(409);

  bool get statusGone => hasStatus(410);

  bool get statusLengthRequired => hasStatus(411);

  bool get statusPreconditionFailed => hasStatus(412);

  bool get statusRequestEntityTooLarge => hasStatus(413);

  bool get statusUnsupportedMediaType => hasStatus(415);

  bool get statusExpectationFailed => hasStatus(417);

  bool get statusLocked => hasStatus(423);

  bool get statusFailedDependency => hasStatus(424);

  bool get statusPreconditionRequired => hasStatus(428);

  bool get statusTooManyRequests => hasStatus(429);

  bool get statusInternalServerError => hasStatus(500);

  bool get statusNotImplemented => hasStatus(501);

  bool get statusBadGateway => hasStatus(502);

  bool get statusServiceUnavailable => hasStatus(503);

  bool get statusGatewayTimeout => hasStatus(504);

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
