/// A repository that provides load functionality using json maps.
abstract class StorageRepository {
  const StorageRepository();

  Future<Map<String, dynamic>?> load(final String key);
}
