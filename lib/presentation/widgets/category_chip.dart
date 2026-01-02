import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Category Chip Widget
class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? color;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Theme.of(context).colorScheme.primary;

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Material(
          elevation: isSelected ? 4 : 0,
          borderRadius: BorderRadius.circular(24.r),
          color: isSelected ? chipColor : Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: isSelected
                      ? chipColor
                      : chipColor.withValues(alpha: 0.3),
                  width: isSelected ? 0 : 1.5.w,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 18.sp,
                      color: isSelected ? Colors.white : chipColor,
                    ),
                    SizedBox(width: 6.w),
                  ],
                  Text(
                    _capitalize(category),
                    style: TextStyle(
                      color: isSelected ? Colors.white : chipColor,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                      fontSize: 14.sp,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
