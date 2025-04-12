import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController {
  static User? user = FirebaseAuth.instance.currentUser;

  static Future<User?> loginWithGoogle() async {
    try {
      final googleAccount = await GoogleSignIn().signIn();
      if (googleAccount == null) return null;

      final googleAuth = await googleAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      user = userCredential.user;
      return user;
    } catch (e) {
      print('Error during Google Sign-In: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    user = null;
  }
}
