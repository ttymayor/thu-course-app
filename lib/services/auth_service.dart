import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '956690934908-9f7rkmj0hi9n3sj7lb93dcltshjjs2kv.apps.googleusercontent.com',
  );

  static const List<String> _allowedDomains = [
    'go.thu.edu.tw',
    'thu.edu.tw',
  ];

  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final domain = googleUser.email.split('@').last;
      if (!_allowedDomains.contains(domain)) {
        await _googleSignIn.signOut();
        throw Exception('僅限東海大學信箱（@go.thu.edu.tw 或 @thu.edu.tw）登入');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (error) {
      print('Google Sign-In error: $error');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
