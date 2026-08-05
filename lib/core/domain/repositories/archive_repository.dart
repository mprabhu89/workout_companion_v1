import 'repository.dart';

abstract interface class ArchiveRepository
    implements Repository {
  Future<void> archive(String id);

  Future<void> restore(String id);
}