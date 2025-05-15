abstract class Userrepositories {
  Future<void> signup(
    String name,
    String email,
    String password,
    String country,
    String role,
  );

  Future<Map<String, dynamic>> login(String email, String password);
}
