import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/user.dart';
import 'user_avatar.dart';

/// Dark curved header with the round profile photo overlapping its edge
/// (the profile layout of the Figma kit).
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final AppUser user;

  static const double _avatarRadius = 56;
  static const double _avatarBorder = 4;

  @override
  Widget build(BuildContext context) {
    // MediaQuery keeps the header proportional on every screen size.
    final headerHeight = MediaQuery.sizeOf(context).height * 0.2;

    return SizedBox(
      height: headerHeight + _avatarRadius + _avatarBorder * 2,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: headerHeight,
            decoration: const BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
          ),
          Positioned(
            top: headerHeight - _avatarRadius,
            child: Container(
              padding: const EdgeInsets.all(_avatarBorder),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: UserAvatar(
                name: user.displayName,
                photoBase64: user.photoBase64,
                radius: _avatarRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
