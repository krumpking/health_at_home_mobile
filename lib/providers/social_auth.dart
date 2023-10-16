import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuth {
  Future<User?> signInWithApple() async {
    final rawNonce = Utilities.generateNonce();
    final nonce = Utilities.sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      WebAuthenticationOptions options =
          WebAuthenticationOptions(clientId: 'com.healthathomemobile.app.login', redirectUri: Uri.parse('https://healthathome-328216.firebaseapp.com/__/auth/handler'));
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
        webAuthenticationOptions: options,
      );

      print(appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      final authResult = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final userEmail = '${appleCredential.email}';

      final user = authResult.user;
      await user!.updateEmail(userEmail);

      return user;
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        print(e.toString());
      }
    }

    return user;
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      //
    }
  }
}
