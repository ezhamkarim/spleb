import 'package:flutter/material.dart';
import 'package:spleb/src/style/style.dart';

class DialogHelper {
  static Future dialogWithAction(BuildContext context, String title, String desc,
      {required void Function() onPressed, bool dismissible = true, bool popAfterPressedYes = true}) {
    return showDialog<bool>(
        barrierDismissible: dismissible,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(desc),
            actions: [
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: CustomColor.primary, side: const BorderSide(color: CustomColor.primary)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  onPressed();
                  if (popAfterPressedYes) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(elevation: 0, foregroundColor: CustomColor.primary),
                child: const Text('Okay'),
              )
            ],
          );
        });
  }

  static Future dialogWithOutActionWarning(
    BuildContext context,
    String title,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0, foregroundColor: CustomColor.primary),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'))
            ],
          );
        });
  }

  static Future dialog(BuildContext context, String title, String desc) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(desc),
            actions: [
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: CustomColor.primary, side: const BorderSide(color: CustomColor.primary)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay')),
            ],
          );
        });
  }
}
