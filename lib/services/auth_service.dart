abstract class AuthService {
  Future<bool> register(String email, String password, String passwordConfirm);
  Future<bool> logIn(String email, String password);
}
