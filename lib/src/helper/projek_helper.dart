import 'package:flutter/material.dart';

class ProjekHelper {
  static Color getColorsStatusBg(String status) {
    switch (status) {
      case 'Belum Disahkan':
        return Colors.yellow;
      case 'Disahkan':
        return Colors.green;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
