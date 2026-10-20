import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Round avatar used everywhere (profile and feed): shows the member's photo
/// when there is one, otherwise the first letter of the name.
class UserAvatar extends StatefulWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.photoBase64,
    this.radius = 20,
  });

  final String name;

  /// Photo stored as base64 text; null when the member has no photo.
  final String? photoBase64;
  final double radius;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  // Decoded once and kept, so the image does not flicker on every rebuild.
  ImageProvider? _photo;

  @override
  void initState() {
    super.initState();
    _photo = _decode(widget.photoBase64);
  }

  @override
  void didUpdateWidget(UserAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoBase64 != widget.photoBase64) {
      _photo = _decode(widget.photoBase64);
    }
  }

  ImageProvider? _decode(String? photoBase64) {
    if (photoBase64 == null) return null;
    try {
      return MemoryImage(base64Decode(photoBase64));
    } on FormatException {
      return null; // a damaged photo is shown as "no photo"
    }
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: AppColors.primaryTint,
      foregroundImage: _photo, // drawn over the initial when present
      child: Text(
        initial,
        style: TextStyle(
          fontSize: widget.radius * 0.7,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
