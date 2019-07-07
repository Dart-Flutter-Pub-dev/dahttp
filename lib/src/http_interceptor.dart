import 'package:http/http.dart';

abstract class HttpInterceptor {
  BaseRequest request(BaseRequest request);

  BaseResponse response(Response response);
}
