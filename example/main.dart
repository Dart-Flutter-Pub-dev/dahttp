import 'dart:convert';
import 'package:dahttp/src/http_client.dart';
import 'package:dahttp/src/http_result.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

main() async {
  var getDogCeo = GetDogCeo();
  var result = await getDogCeo.call();

  if (result.isSuccessful) {
    print('Result: ${result.value.url}');
  } else if (result.isUnsuccessful) {
    print('Error: ${result.response.statusCode}');
  } else if (result.hasFailed) {
    print('Exception: ${result.exception}');
  }
}

class GetDogCeo extends ValueHttp<DogCeo> {
  Future<HttpResult<DogCeo>> call() {
    return super.get('https://dog.ceo/api/breeds/image/random');
  }

  @override
  DogCeo convert(Response response) {
    return DogCeo.fromJson(response.body);
  }
}

@immutable
class DogCeo {
  final String url;

  DogCeo(this.url);

  static DogCeo fromJson(String json) {
    var data = jsonDecode(json);

    return DogCeo(data['message']);
  }
}
