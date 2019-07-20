# Dahttp

HTTP wrapper for Dart with integrated logger design to be used for REST APIs.

## Installation

Add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies: 
  dahttp: ^1.9.5
```

## Example

```dart
Future<void> main() async {
  final GetDogCeo getDogCeo = GetDogCeo();
  final HttpResult<DogCeo> result = await getDogCeo.call();

  // checking boolean properties
  if (result.isSuccess) {
    print('Success: ${result.data.url}');
  } else if (result.isError) {
    print('Error: ${result.response.statusCode}');
  } else if (result.hasException) {
    print('Exception: ${result.exception}');
  }

  // passing callbacks (named parameters)
  result.handle(success: (DogCeo dog, Response response) {
    print('Success: ${dog.url}');
  }, error: (Response response) {
    print('Error: ${response.statusCode}');
  }, exception: (dynamic exception) {
    print('Exception: $exception');
  });

  // passing callbacks (chained notation)
  result.onSuccess((DogCeo dog, Response response) {
    print('Success: ${dog.url}');
  }).onError((Response response) {
    print('Error: ${response.statusCode}');
  }).onException((dynamic exception) {
    print('Exception: $exception');
  });

  // passing callbacks (cascade notation)
  result
    ..onSuccess((DogCeo dog, Response response) {
      print('Success: ${dog.url}');
    })
    ..onError((Response response) {
      print('Error: ${response.statusCode}');
    })
    ..onException((dynamic exception) {
      print('Exception: $exception');
    });
}
```

```dart
@immutable
class GetDogCeo extends ValuedHttpClient<DogCeo> {
  Future<HttpResult<DogCeo>> call() =>
      super.get('https://dog.ceo/api/breeds/image/random');

  @override
  DogCeo convert(Response response) => DogCeo.fromJson(response.body);
}
```

```dart
@immutable
class DogCeo {
  final String url;

  const DogCeo(this.url);

  static DogCeo fromJson(String json) {
    final dynamic data = jsonDecode(json);

    return DogCeo(data['message']);
  }
}
```