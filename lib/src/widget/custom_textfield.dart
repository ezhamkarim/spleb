import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/style/style.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.isObscure,
      required this.isEnabled,
      this.keyboardType,
      this.onTap,
      this.validator,
      this.color});
  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final bool isEnabled;
  final TextInputType? keyboardType;
  final Color? color;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = false;

  @override
  void initState() {
    super.initState();

    isObscure = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            widget.hintText,
            style: TextStyle(color: widget.color ?? Colors.white),
          ),
        ),
        SizedBoxHelper.sizedboxH8,
        TextFormField(
          onTap: widget.onTap,
          controller: widget.controller,
          validator: widget.validator ??
              (string) {
                // if (widget.hintText == 'Huraian' || widget.hintText == 'No Tel' || widget.hintText == 'No Kp') return null;

                if (string == null || string.isEmpty) {
                  return 'Sila masukkan aksara';
                }
                // if (widget.hintText == 'No Kp' && string.length != 12) {
                //   return 'Sila masukkan nric yang betul';
                // }
                if (widget.isObscure && string.length < 8) {
                  return 'Sila masukkan kata laluan melebihi 8 aksara';
                }
                return null;
              },
          inputFormatters: [
            if (widget.hintText == 'No Kp') LengthLimitingTextInputFormatter(12),
            if (widget.keyboardType == TextInputType.number) FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))
          ],
          obscureText: isObscure,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
              enabled: widget.isEnabled,
              suffixIcon: widget.isObscure
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      icon: FaIcon(
                        isObscure ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                        color: Colors.black,
                      ))
                  : null,
              // hintText: widget.hintText,
              fillColor: Colors.white,
              filled: true,
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.5), width: 2),
                  borderRadius: const SmoothBorderRadius.all(SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: widget.color ?? Colors.white, width: 2),
                  borderRadius: const SmoothBorderRadius.all(SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red.shade800, width: 2),
                  borderRadius: const SmoothBorderRadius.all(SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: CustomColor.secondary, width: 2),
                  borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6)))),
        ),
      ],
    );
  }
}
