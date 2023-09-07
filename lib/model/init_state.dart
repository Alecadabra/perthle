enum InitState {
  firebase(loadingMessage: 'firebase'),
  firestore(loadingMessage: 'store'),
  appCheck(loadingMessage: 'appcheck'),
  auth(loadingMessage: 'auth'),
  login(loadingMessage: 'login'),
  finished(loadingMessage: 'done');

  const InitState({required this.loadingMessage});

  final String loadingMessage;

  bool get isDone => this == InitState.done;

  static const InitState initial = InitState.firebase;
  static const InitState done = InitState.finished;
}
