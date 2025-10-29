// features/authentication/presentation/widgets/primary_button.dart (Animated Version)

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final IconData? icon;
  final bool showIcon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 52,
    this.icon,
    this.showIcon = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null && !widget.isLoading;

    return GestureDetector(
      onTapDown: isDisabled || widget.isLoading
          ? null
          : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabled || widget.isLoading
          ? null
          : (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLoading || isDisabled ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width ?? double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          gradient: isDisabled || widget.isLoading
              ? AppColors.disabledButtonGradient
              : AppColors.primaryButtonGradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: isDisabled || _isPressed
              ? null
              : [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isLoading || isDisabled ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(12),
            splashColor: Colors.white.withOpacity(0.1),
            highlightColor: Colors.white.withOpacity(0.05),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: _buildButtonContent(isDisabled),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(bool isDisabled) {
    if (widget.isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (widget.showIcon && widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: isDisabled
                ? AppColors.buttonDisabledText
                : AppColors.buttonPrimaryText,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            widget.label,
            style: AppTypography.button.copyWith(
              color: isDisabled
                  ? AppColors.buttonDisabledText
                  : AppColors.buttonPrimaryText,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      widget.label,
      style: AppTypography.button.copyWith(
        color: isDisabled
            ? AppColors.buttonDisabledText
            : AppColors.buttonPrimaryText,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
