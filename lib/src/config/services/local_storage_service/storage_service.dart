abstract class ATLocalStorageService {
  
  Future<void> remove(String key);

  Future<String?> get(String key);

  Future<void> set(String key, String? data);

  Future<void> clear();

  Future<void> setObject<T>(String key, T value);

  Future<T?> getObject<T>(String key);
}
