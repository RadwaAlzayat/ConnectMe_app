import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/user.dart';

/// Dark curved header with the round profile photo overlapping its edge
/// (the profile layout of the Figma kit).
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final AppUser user;

  static const double _avatarRadius = 56;
  static const double _avatarBorder = 4;

  /// The stored photo is base64 text; null when there is no (valid) photo.
  ImageProvider? get _photo {
    final photoBase64 = user.photoBase64;
    if (photoBase64 == null) return null;
    try {
      return MemoryImage(base64Decode(photoBase64));
    } on FormatException {
      return null; // a damaged photo is shown as "no photo"
    }
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery keeps the header proportional on every screen size.
    final headerHeight = MediaQuery.sizeOf(context).height * 0.2;
    final initial = user.displayName.isNotEmpty
        ? user.displayName[0].toUpperCase()
        : '?';

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
              child: CircleAvatar(
                radius: _avatarRadius,
                backgroundColor: AppColors.primaryTint,
                foregroundImage: _photo, // drawn over the initial when present
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
