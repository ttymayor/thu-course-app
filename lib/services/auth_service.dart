import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  late final GoogleSignIn _googleSignIn;

  AuthService() {
    final clientId = dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
    _googleSignIn = GoogleSignIn(
      clientId: clientId,
      serverClientId: clientId,
      scopes: ['email', 'profile'],
    );
  }

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      return account;
    } catch (error) {
      print('Google Sign-In error: $error');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<GoogleSignInAccount?> getCurrentUser() async {
    return await _googleSignIn.currentUser;
  }
}
