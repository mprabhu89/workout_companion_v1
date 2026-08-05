/* import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatabase {
  IsarDatabase._();

  static Isar? _instance;

  static Future<Isar> instance() async {
    if (_instance != null) {
      return _instance!;
    }

    final directory =
        await getApplicationDocumentsDirectory();

    _instance = await Isar.open(
      [
        // Schemas will be added here
      ],
      directory: directory.path,
      inspector: true,
    );

    return _instance!;
  }

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}
*/