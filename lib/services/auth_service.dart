import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  static const String _clientId = String.fromEnvironment('GOOGLE_CLIENT_ID');
  static const String _sessionKey = 'login_timestamp';
  static const int _sessionDays = 30;

  late final GoogleSignIn _googleSignIn;

  AuthService._internal() {
    _googleSignIn = GoogleSignIn(
      clientId: _clientId,
      serverClientId: _clientId,
      scopes: ['email', 'profile'],
    );
  }

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      return await _googleSignIn.signIn();
    } catch (error) {
      print('Google Sign-In error: $error');
      return null;
    }
  }

  Future<GoogleSignInAccount?> signInSilently() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> isSessionValid() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_sessionKey);
    if (timestamp == null) return false;
    final loginTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(loginTime).inDays < _sessionDays;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await clearSession();
  }

  Future<GoogleSignInAccount?> getCurrentUser() async {
    return _googleSignIn.currentUser;
  }
}
