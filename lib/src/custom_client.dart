import 'package:dahttp/src/http_logger.dart';
import 'package:http/http.dart';

class CustomClient extends BaseClient {
  final Client _client = Client();
  final DefaultHttpLogger _logger;

  CustomClient(this._logger);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    _logger.request(request);
    return _client.send(request);
  }

  @override
  void close() => _client.close();
}
