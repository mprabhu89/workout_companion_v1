import 'repository.dart';

abstract interface class WriteRepository<T>
    implements Repository {
  Future<void> save(T entity);
}