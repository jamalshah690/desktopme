import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:flutter/material.dart';

class BookingTabs extends StatelessWidget {
  final String title;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;
  const BookingTabs({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 10),
          height: 45,
          padding: isSelected
              ? EdgeInsets.symmetric(
                  horizontal: index == 1 ? 6 : 18,
                  vertical: index == 1 ? 3 : 6,
                )
              : null,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            textAlign: TextAlign.center,
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
              color: isSelected
                  ? AppColors.black
                  : AppColors.black.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
