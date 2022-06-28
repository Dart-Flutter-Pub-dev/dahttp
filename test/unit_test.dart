import 'dart:convert';
import 'package:dahttp/src/http_client.dart';
import 'package:dahttp/src/http_logger.dart';
import 'package:dahttp/src/http_result.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  group('dahttp', () {
    test('get web page', () async {
      final GetWebPage getWebPage = GetWebPage();
      final HttpResult<WebPage> result = await getWebPage.call();

      expect(result.status, equals(200));
      expect(result.success, isTrue);
      expect(result.body, isNotEmpty);
    });

    test('get empty', () async {
      final GetEmpty getEmpty = GetEmpty();
      final HttpResult<void> result = await getEmpty.call();

      expect(result.status, equals(204));
      expect(result.success, isTrue);
      expect(result.body, isEmpty);
    });

    test('post web page', () async {
      final PostSample postSample = PostSample();
      final HttpResult<void> result = await postSample.call();

      expect(result.status, equals(201));
      expect(result.success, isTrue);
      expect(result.body, isEmpty);
    });

    test('put web page', () async {
      final PutSample putSample = PutSample();
      final HttpResult<void> result = await putSample.call();

      expect(result.status, equals(200));
      expect(result.success, isTrue);
      expect(result.body, isEmpty);
    });

    test('patch web page', () async {
      final PatchSample patchSample = PatchSample();
      final HttpResult<void> result = await patchSample.call();

      expect(result.status, equals(200));
      expect(result.success, isTrue);
      expect(result.body, isEmpty);
    });

    test('delete web page', () async {
      final DeleteSample deleteSample = DeleteSample();
      final HttpResult<void> result = await deleteSample.call();

      expect(result.status, equals(204));
      expect(result.success, isTrue);
      expect(result.body, isEmpty);
    });

    test('non existent end point', () async {
      final NonExistentEndPoint nonExistent = NonExistentEndPoint();
      final HttpResult<void> result = await nonExistent.call();

      expect(result.hasException, isTrue);
    });
  });
}

const String URL = 'https://dahttp.free.beeceptor.com';

class GetWebPage extends ValuedHttpClient<WebPage> {
  GetWebPage() : super(logger: DefaultHttpLogger());

  Future<HttpResult<WebPage>> call() {
    return super.get('$URL/get-full');
  }

  @override
  WebPage convert(Response response) {
    return WebPage.json(response.body);
  }
}

class GetEmpty extends EmptyHttpClient {
  GetEmpty() : super(logger: DefaultHttpLogger());

  Future<HttpResult<void>> call() {
    return super.get('$URL/get-empty');
  }
}

class PostSample extends EmptyHttpClient {
  PostSample() : super(logger: DefaultHttpLogger());

  Future<HttpResult<void>> call() {
    return super.post('$URL/post', body: '{}');
  }
}

class PutSample extends EmptyHttpClient {
  PutSample() : super(logger: DefaultHttpLogger());

  Future<HttpResult<void>> call() {
    return super.put('$URL/put', body: '{}');
  }
}

class PatchSample extends EmptyHttpClient {
  PatchSample() : super(logger: DefaultHttpLogger());

  Future<HttpResult<void>> call() {
    return super.patch('$URL/patch', body: '{}');
  }
}

class DeleteSample extends EmptyHttpClient {
  DeleteSample() : super(logger: DefaultHttpLogger());

  Future<HttpResult<void>> call() {
    return super.delete('$URL/delete');
  }
}

class NonExistentEndPoint extends EmptyHttpClient {
  NonExistentEndPoint() : super(logger: DefaultHttpLogger());

  static const String URL = 'https://nonexistent.com';

  Future<HttpResult<void>> call() {
    return super.get(URL);
  }
}

class WebPage {
  final String? url;

  const WebPage(this.url);

  factory WebPage.json(String json) {
    final dynamic data = jsonDecode(json);

    return WebPage(data['url']);
  }
}
