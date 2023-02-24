import 'package:flutter/material.dart';

class SizeConfig {
  final BuildContext _ctxt;

  SizeConfig(this._ctxt);

  double scaledWidth({double? widthScale}) {
    widthScale ??= 1;
    return MediaQuery.of(_ctxt).size.width * widthScale;
  }

  double topSafeArea() {
    return MediaQuery.of(_ctxt).padding.top;
  }

  double bottomNavBar() {
    return MediaQuery.of(_ctxt).padding.bottom;
  }

  double scaledHeight({double? heightScale}) {
    heightScale ??= 1;
    return MediaQuery.of(_ctxt).size.height * heightScale;
  }
}

class SizedBoxHelper {
  static const sizedboxH8 = SizedBox(
    height: 8,
  );

  static const sizedboxH16 = SizedBox(
    height: 16,
  );
  static const sizedboxH32 = SizedBox(
    height: 32,
  );
}
