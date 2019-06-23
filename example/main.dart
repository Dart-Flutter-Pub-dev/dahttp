import 'dart:convert';
import 'package:dahttp/src/dahttp.dart';
import 'package:dahttp/src/http_result.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

main() async {
  var getWebPage = GetWebPage();
  var result = await getWebPage.call();

  if (result.isSuccessful) {
    print('Result: ${result.value}');
  } else if (result.isUnsuccessful) {
    print('Error: ${result.response.statusCode}');
  } else if (result.hasFailed) {
    print('Exception: ${result.exception}');
  }
}

class GetWebPage extends ValueHttp<WebPage> {
  Future<HttpResult<WebPage>> call() {
    return super.get('https://foo.com/bar');
  }

  @override
  WebPage convert(Response response) {
    return WebPage.json(response.body);
  }
}

abstract class RestEndPoint<T> extends ValueHttp<T> {
  @override
  Future<HttpResult<T>> get(url, {Map<String, String> headers}) async {
    Map<String, String> newHeaders = headers ?? Map();
    newHeaders['aa'] = 'xx';

    return super.get(url, headers: newHeaders);
  }
}

@immutable
class WebPage {
  final String url;

  WebPage(this.url);

  static WebPage json(String json) {
    var data = jsonDecode(json);

    return WebPage(data['url']);
  }
}
