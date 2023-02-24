import 'package:firebase_core/firebase_core.dart';
import 'package:spleb/src/helper/log_helper.dart';

class AuthService {
  //TODO implement all service 9:00 AM

  Future<String?> signIn() async {
    try {
      /// sign in
      ///
      ///
      ///
      return null;
    } on FirebaseException catch (e) {
      logError('Firebase Error $e');
      throw e.toString();
    } catch (e) {
      logError('Other Error $e');

      throw e.toString();
    }
  }

  Future<void> signUp() async {}

  Future<void> deleteUser() async {}

  Future<void> sendPassword() async {}

  Future<void> updatePassword() async {}

  Future<void> updateProfile() async {}
}
