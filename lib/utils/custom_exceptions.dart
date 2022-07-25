class FileSizeException implements Exception {
  final String message;

  FileSizeException(this.message);

  @override
  String toString() => message;
}
