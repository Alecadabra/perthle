class JsonSerializableData<T> {
  JsonSerializableData.fromJson(final Map<String, dynamic> json)
      : assert(false, 'fromJson not implemented');

  Map<String, dynamic> toJson() {
    throw UnimplementedError('toJson not implemented');
  }
}
