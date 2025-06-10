abstract class Userrepositories {
  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
    String country,
    String role,
  );

  Future<Map<String, dynamic>> login(String email, String password);
  Future<void> logout();
}
