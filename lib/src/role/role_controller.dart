import 'package:spleb/src/enum/viewstate_enum.dart';
import 'package:spleb/src/model/role.dart';
import 'package:spleb/src/root/providers.dart';
import 'package:spleb/src/root/services.dart';

class RoleController extends RootProvider {
  final RoleService _roleService = RoleService();
  Future<void> create(Role role) async {
    try {
      setState = ViewState.busy;
      /**
       * 
       */

      // await _roleService.create();
      setState = ViewState.idle;
      return;
    } catch (e) {
      setState = ViewState.idle;
      rethrow;
    }
  }

  void read() {}
}
