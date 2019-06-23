import 'dart:convert';
import 'package:dahttp/src/dahttp.dart';
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
    var client = CustomClient(logger);

    try {
      var response = await client.get(url, headers: headers);
      logger.response(response);

      return HttpResult<T>(response: response, value: convert(response));
    } catch (e) {
      return HttpResult<T>(exception: e);
    } finally {
      client.close();
    }
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
