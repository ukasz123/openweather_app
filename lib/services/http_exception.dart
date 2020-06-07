class HttpException implements Exception {
  final int statusCode;
  final String reasonPhrase;

  HttpException(this.statusCode, this.reasonPhrase);

  @override
  String toString() {
  return "HttpException ($statusCode): $reasonPhrase";
   }
}