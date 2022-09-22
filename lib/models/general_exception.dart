class GeneralException implements Exception {
  final String errorMessage;

  GeneralException(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}
