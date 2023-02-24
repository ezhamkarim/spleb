import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:spleb/src/enum/viewstate_enum.dart';
import 'package:spleb/src/style/style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.titleButton,
      required this.onPressed,
      this.viewState = ViewState.idle,
      this.btnColor,
      this.isOutlined = false})
      : super(key: key);
  final String titleButton;
  final ViewState viewState;
  final Color? btnColor;
  final bool isOutlined;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: isOutlined
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                  foregroundColor: btnColor,
                  side: BorderSide(color: btnColor ?? CustomColor.primary, width: 2),
                  shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                    cornerRadius: 4,
                    cornerSmoothing: 0.6,
                  ))),
              onPressed: viewState == ViewState.busy ? null : onPressed,
              child: viewState == ViewState.idle
                  ? Text(
                      titleButton,
                      style: const TextStyle(fontSize: 18),
                    )
                  : const CircularProgressIndicator(
                      color: Colors.white,
                    ))
          : ElevatedButton(
              onPressed: viewState == ViewState.busy ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor ?? CustomColor.primary,
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 4,
                    cornerSmoothing: 0.6,
                  ),
                ),
              ),
              child: viewState == ViewState.idle
                  ? Text(
                      titleButton,
                      style: const TextStyle(fontSize: 18),
                    )
                  : const CircularProgressIndicator(
                      color: Colors.white,
                    )),
    );
  }
}
