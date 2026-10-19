import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/failures.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/user.dart';
import '../blocs/profile_cubit.dart';
import '../blocs/profile_state.dart';
import '../widgets/error_message_view.dart';
import '../widgets/gradient_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_tile.dart';

/// Shows the member's photo, name, email and phone details. Opened only
/// after the fingerprint check passes (see HomeScreen).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.signedInUser});

  /// Needed so the "Try again" button can reload the profile.
  final AppUser signedInUser;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUpdatingPhoto = false;

  Future<void> _changePhoto() async {
    // Taken before the await, so no BuildContext is used after the gap.
    final messenger = ScaffoldMessenger.of(context);
    final profileCubit = context.read<ProfileCubit>();

    setState(() => _isUpdatingPhoto = true);
    try {
      await profileCubit.changePhoto();
    } on Failure catch (failure) {
      messenger.showSnackBar(SnackBar(content: Text(failure.message)));
    } finally {
      if (mounted) setState(() => _isUpdatingPhoto = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sidePadding = MediaQuery.sizeOf(context).width * 0.08;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) => switch (state) {
          ProfileLoading() => const Center(child: CircularProgressIndicator()),
          ProfileError(:final message) => ErrorMessageView(
            message: message,
            onRetry: () =>
                context.read<ProfileCubit>().load(widget.signedInUser),
          ),
          ProfileLoaded(:final user, :final device) => SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(user: user),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sidePadding),
                  child: Column(
                    children: [
                      Text(
                        user.displayName,
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            ProfileInfoTile(
                              icon: Icons.phone_android,
                              label: 'Device model',
                              value: device.model,
                            ),
                            const Divider(height: 24),
                            ProfileInfoTile(
                              icon: Icons.android,
                              label: 'OS version',
                              value: device.osVersion,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      GradientButton(
                        label: 'Change photo',
                        isLoading: _isUpdatingPhoto,
                        onPressed: _changePhoto,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        },
      ),
    );
  }
}
