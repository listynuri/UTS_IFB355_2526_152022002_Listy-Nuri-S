// lib/screens/soft_app_bar.dart
import 'package:flutter/material.dart';
import '../theme.dart';

class RoundedBackButton extends StatelessWidget {
  const RoundedBackButton({
    super.key,
    this.onPressed,
    this.icon = Icons.arrow_back_ios_new,
    this.size = 36,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final green = AppColors.oliveMist;
    return Material(
      color: green,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed ?? () => Navigator.maybePop(context),
        splashColor: Colors.white.withOpacity(.25),
        highlightColor: Colors.white.withOpacity(.15),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}

class SoftTopBar extends StatelessWidget implements PreferredSizeWidget {
  SoftTopBar({
    super.key,
    required this.title,
    this.onBack,
    this.showAvatar = false,
    this.profileAsset = 'assets/images/profile.png',
    this.actions,
    this.horizontalMargin = 12,
    this.verticalMargin = 8,
    this.radius = 16,
    this.roundAll = true, // <- bikin atas & bawah rounded
  });

  final String title;
  final VoidCallback? onBack;
  final bool showAvatar;
  final String profileAsset;
  final List<Widget>? actions;

  final double horizontalMargin;
  final double verticalMargin;
  final double radius;
  final bool roundAll;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final shape =
        roundAll
            ? BorderRadius.circular(radius)
            : BorderRadius.vertical(bottom: Radius.circular(radius));

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalMargin,
            verticalMargin,
            horizontalMargin,
            0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: shape,
              border: Border.all(color: const Color(0x14000000)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: [
                  RoundedBackButton(onPressed: onBack),
                  const SizedBox(width: 10),
                  if (showAvatar) ...[
                    ClipOval(
                      child: Image.asset(
                        profileAsset,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: 36,
                              height: 36,
                              color: const Color(0xFFEDEDED),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.person,
                                size: 18,
                                color: Colors.black54,
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  if (actions != null) ...actions!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
