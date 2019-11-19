class InvalidPlaylistException implements Exception {
  final message;

  InvalidPlaylistException([this.message]);

  @override
  String toString() => message == null ? "InvalidPlaylistException" : "InvalidPlaylistException: $message";
}
