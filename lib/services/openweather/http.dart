import 'package:http/http.dart' as http;

class OpenWeatherHttpClient extends http.BaseClient {
  final String apiKey;
  final http.Client _client;

  OpenWeatherHttpClient(this.apiKey) : _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    var url = request.url;
    var queryParams = Map<String, String>.from(url.queryParameters);
    queryParams['appid'] = apiKey;
    var amendedUrl = url.replace(queryParameters: queryParams);
    var finalRequest = http.Request(request.method, amendedUrl)
      ..headers.addAll(request.headers);
    return _client.send(finalRequest);
  }
}
