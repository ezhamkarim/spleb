import 'package:spleb/src/auth/auth_service.dart';
import 'package:spleb/src/enum/viewstate_enum.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/providers.dart';

class AuthController extends RootProvider {
  final AuthService _authService = AuthService();

  Future<SplebUser?> login(SplebUser user) async {
    try {
      setState = ViewState.busy;
      /**
       * 
       */

      await _authService.signIn();
      setState = ViewState.idle;
      return null;
    } catch (e) {
      setState = ViewState.idle;
      rethrow;
    }
  }

  Future<void> register(SplebUser user) async {
    try {
      setState = ViewState.busy;
      /**
       * 
       */
      await _authService.signUp();
      setState = ViewState.idle;
      return;
    } catch (e) {
      setState = ViewState.idle;
      rethrow;
    }
  }

  Future<void> updatePassword(String newPassword, String oldPassword) async {
    try {
      setState = ViewState.busy;
      /**
       * 
       */
      setState = ViewState.idle;
      await _authService.updatePassword();
      return;
    } catch (e) {
      setState = ViewState.idle;
      rethrow;
    }
  }
}
