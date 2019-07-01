# Dahttp

HTTP wrapper for Dart with integrated logger design to be used for REST APIs.

## Installation

Add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies: 
  dahttp: ^1.4.1
```

## Example

```dart
main() async {
  var getDogCeo = GetDogCeo();
  var result = await getDogCeo.call();

  if (result.isSuccessful) {
    print('Result: ${result.data.url}');
  } else if (result.isUnsuccessful) {
    print('Error: ${result.response.statusCode}');
  } else if (result.hasFailed) {
    print('Exception: ${result.exception}');
  }
}
```

```dart
class GetDogCeo extends ValueHttp<DogCeo> {
  Future<HttpResult<DogCeo>> call() {
    return super.get('https://dog.ceo/api/breeds/image/random');
  }

  @override
  DogCeo convert(Response response) {
    return DogCeo.fromJson(response.body);
  }
}
```

```dart
@immutable
class DogCeo {
  final String url;

  DogCeo(this.url);

  static DogCeo fromJson(String json) {
    var data = jsonDecode(json);

    return DogCeo(data['message']);
  }
}
```