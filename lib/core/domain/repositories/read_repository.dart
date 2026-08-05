import 'repository.dart';

abstract interface class ReadRepository<T>
    implements Repository {
  Future<List<T>> getAll();

  Future<T?> getById(String id);
}