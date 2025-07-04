 
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget childWidget;
  final double? width;
  final double? height;
  final double? borderRadius, elevation;
  final bool isShape;
  final IconData? iconData;

  final Color? bgColor;
  final Gradient? gradient;  

  const PrimaryButton({
    Key? key,
    required this.onTap,
    this.isShape = false,
    required this.childWidget,
    this.width,
    this.height,
    this.elevation = 5,
    this.borderRadius = 7,
    required this.bgColor,
    this.iconData,
    this.gradient, // 🔥 Add this
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: elevation ?? 2,
        shape: isShape
            ? const CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius!),
              ),
        child: Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          height: height ?? 55 ,
          alignment: Alignment.center,
          width: width ?? 100  ,
          decoration: BoxDecoration(
            gradient: gradient, 
            color: gradient == null ? bgColor : null,
            shape: isShape ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isShape ? null : BorderRadius.circular(borderRadius!),
          ),
          child: childWidget,
        ),
      ),
    );
  }
}