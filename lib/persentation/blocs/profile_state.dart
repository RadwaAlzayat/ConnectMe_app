import '../../domain/entities/device_details.dart';
import '../../domain/entities/user.dart';

/// Every state the profile screen can be in.
sealed class ProfileState {
  const ProfileState();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.user, required this.device});

  final AppUser user;
  final DeviceDetails device;
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;
}
