import 'repository.dart';

abstract interface class NamedRepository<T>
    implements Repository {
  Future<bool> existsByName(String name);
}