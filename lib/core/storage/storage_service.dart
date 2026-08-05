abstract interface class StorageService {
  Future<void> initialize();

  Future<void> close();
}