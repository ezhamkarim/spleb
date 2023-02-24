import 'package:flutter/material.dart';
import 'package:spleb/src/enum/viewstate_enum.dart';

class RootProvider extends ChangeNotifier {
  ViewState _viewState = ViewState.idle;

  set setState(ViewState vs) {
    _viewState = vs;
    notifyListeners();
  }

  ViewState get viewState => _viewState;
}
