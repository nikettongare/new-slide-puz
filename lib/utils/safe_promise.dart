class IPromiseResult {
  final dynamic response, hasError, error;

  IPromiseResult({
    this.hasError,
    this.error,
    this.response,
  });
}

Future<IPromiseResult> promiseHandler(Future promise) {
  return promise
      .then((data) =>
          IPromiseResult(hasError: false, error: null, response: data))
      .catchError((err) => IPromiseResult(hasError: true, error: err));
}
