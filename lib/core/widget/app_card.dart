import 'package:flutter/material.dart';
import '../constant/app_color.dart';

class AppCard extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool hasBorder;

  const AppCard({
    super.key,
    this.height,
    this.width,
    this.child,
    this.color = Colors.white,
    this.margin,
    this.padding,
    this.borderRadius,
    this.onTap,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderStyle = hasBorder
        ? Border.all(color: AppColor.primary.withOpacity(0.1), width: 1.2)
        : null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        margin: margin ?? const EdgeInsets.all(8),
        padding: padding ?? const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          border: borderStyle,
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
          boxShadow: [
            BoxShadow(
              color: AppColor.surface.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}