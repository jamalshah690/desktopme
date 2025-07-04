 
import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFieldComponents extends StatelessWidget {
  final String hint;
  final String? suffixIconSvg;
  final String? prefixIconSvg;
  final TextEditingController controller;
  final VoidCallback? onpressed;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? labelWidget;
  final bool enabled;
  const CustomFieldComponents({
    super.key,
    required this.hint,
    this.suffixIconSvg,
    this.enabled = false,
    this.inputFormatters,
    this.prefixIconSvg,
    this.onpressed,
    this.validator,
    this.labelWidget,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      contextMenuBuilder: (context, editableTextState) {
    // 👇 This disables long press/double tap context menu
    return const SizedBox.shrink();
  },
      readOnly: enabled,
      onTapOutside: (v) {
        FocusScope.of(context).unfocus();
      },
      onTap: onTap ?? () {},
      keyboardType: keyboardType,
      cursorColor: AppColors.KBlacks,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        color: AppColors.kBlackColor,
        fontWeight: FontWeight.w400,
      ),
      obscureText: obscureText,
      decoration: InputDecoration(
        label: labelWidget,
        filled: true,
        fillColor: AppColors.kWhiteColor,
        contentPadding: EdgeInsets.symmetric(
          vertical: 16,
        ).copyWith(left: 12),
        focusColor: Colors.white,
        hintText: hint,
         
         
         
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32 ),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(32.0 ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32 ),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        // focusedErrorBorder: OutlineInputBorder(
        //   borderSide: const BorderSide(color: Colors.red),
        //   borderRadius: BorderRadius.circular(15.0.r),
        // ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32 ),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        errorStyle: const TextStyle(color: Colors.red, height: 0),
      ),
      controller: controller,
      validator: validator,
      onChanged: onChanged,
    );
  }
}