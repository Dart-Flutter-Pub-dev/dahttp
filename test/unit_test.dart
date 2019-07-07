import 'dart:convert';
import 'package:dahttp/src/http_client.dart';
import 'package:dahttp/src/http_logger.dart';
import 'package:dahttp/src/http_result.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

void main() {
  group('dahttp', () {
    test('get web page', () async {
      final GetWebPage getWebPage = GetWebPage();
      final HttpResult<WebPage> result = await getWebPage.call();

      expect(result.response.statusCode, equals(200));
      expect(result.isSuccess, isTrue);
      expect(result.response.body, isNotEmpty);
    });

    test('get empty', () async {
      final GetEmpty getEmpty = GetEmpty();
      final HttpResult<void> result = await getEmpty.call();

      expect(result.response.statusCode, equals(200));
      expect(result.isSuccess, isTrue);
      expect(result.response.body, isEmpty);
    });

    test('post web page', () async {
      final PostSample postSample = PostSample();
      final HttpResult<void> result = await postSample.call();

      expect(result.response.statusCode, equals(201));
      expect(result.isSuccess, isTrue);
      expect(result.response.body, isEmpty);
    });

    test('put web page', () async {
      final PutSample putSample = PutSample();
      final HttpResult<void> result = await putSample.call();

      expect(result.response.statusCode, equals(200));
      expect(result.isSuccess, isTrue);
      expect(result.response.body, isEmpty);
    });

    test('patch web page', () async {
      final PatchSample patchSample = PatchSample();
      final HttpResult<void> result = await patchSample.call();

      expect(result.response.statusCode, equals(200));
      expect(result.isSuccess, isTrue);
      expect(result.response.body, isEmpty);
    });

    test('delete web page', () async {
      final DeleteSample deleteSample = DeleteSample();
      final HttpResult<void> result = await deleteSample.call();

      expect(result.response.statusCode, equals(200));
      expect(result.isSuccess, isTrue);
      expect(result.response.body, isEmpty);
    });

    test('non existent end point', () async {
      final NonExistentEndPoint nonExistent = NonExistentEndPoint();
      final HttpResult<void> result = await nonExistent.call();

      expect(result.hasException, isTrue);
    });
  });
}

class GetWebPage extends ValueHttp<WebPage> {
  GetWebPage() : super(logger: DefaultHttpLogger());

  Future<HttpResult<WebPage>> call() {
    return super.get('https://demo4798213.mockable.io/webpage');
  }

  @override
  WebPage convert(Response response) {
    return WebPage.json(response.body);
  }
}

class GetEmpty extends EmptyHttp {
  GetEmpty() : super(logger: DefaultHttpLogger());

  Future<HttpResult<void>> call() {
    return super.get('https://demo4798213.mockable.io/empty');
  }
}

class PostSample extends EmptyHttp {
  PostSample() : super(logger: DefaultHttpLogger());

  Future<HttpResult<void>> call() {
    return super.post('https://demo4798213.mockable.io/post', body: '{}');
  }
}

class PutSample extends EmptyHttp {
  PutSample() : super(logger: DefaultHttpLogger());

  Future<HttpResult<void>> call() {
    return super.put('https://demo4798213.mockable.io/put', body: '{}');
  }
}

class PatchSample extends EmptyHttp {
  PatchSample() : super(logger: DefaultHttpLogger());

  Future<HttpResult<void>> call() {
    return super.patch('https://demo4798213.mockable.io/patch', body: '{}');
  }
}

class DeleteSample extends EmptyHttp {
  DeleteSample() : super(logger: DefaultHttpLogger());

  Future<HttpResult<void>> call() {
    return super.delete('https://demo4798213.mockable.io/delete');
  }
}

class NonExistentEndPoint extends EmptyHttp {
  NonExistentEndPoint() : super(logger: DefaultHttpLogger());

  static const String URL = 'https://nonexistent.com';

  Future<HttpResult<void>> call() {
    return super.get(URL);
  }
}

@immutable
class WebPage {
  final String url;

  const WebPage(this.url);

  static WebPage json(String json) {
    final dynamic data = jsonDecode(json);

    return WebPage(data['url']);
  }
}
