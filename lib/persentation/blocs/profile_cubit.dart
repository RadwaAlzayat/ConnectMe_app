import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_builder.dart';
import '../../services/biometric_service.dart';
import '../../services/device_info_service.dart';
import '../../services/photo_picker_service.dart';
import '../../services/profile_service.dart';
import 'profile_state.dart';

/// Owns everything about the signed-in member's profile: the fingerprint
/// gate, the data shown (account + device info) and the profile photo.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._profileService,
    this._deviceInfoService,
    this._photoPickerService,
    this._biometricService,
  ) : super(const ProfileLoading());

  final ProfileService _profileService;
  final DeviceInfoService _deviceInfoService;
  final PhotoPickerService _photoPickerService;
  final BiometricService _biometricService;

  StreamSubscription<AppUser?>? _profileSubscription;

  /// Asks for the fingerprint. True = access granted. Throws a [Failure]
  /// with a friendly message when the check cannot be done.
  Future<bool> verifyIdentity() => _biometricService.authenticate();

  /// Loads the device info and starts listening to the stored profile, so a
  /// new photo appears on screen as soon as it is saved.
  Future<void> load(AppUser signedInUser) async {
    emit(const ProfileLoading());
    final device = await _deviceInfoService.getDeviceDetails();
    if (isClosed) return; // the user may have left while we were waiting

    await _profileSubscription?.cancel();
    _profileSubscription = _profileService
        .watchProfile(signedInUser.uid)
        .listen(
          (storedProfile) => emit(
            ProfileLoaded(
              user: _buildUser(signedInUser, storedProfile?.photoBase64),
              device: device,
            ),
          ),
          onError: (Object error) => emit(
            ProfileError(
              error is Failure ? error.message : const UnknownFailure().message,
            ),
          ),
        );
  }

  /// Lets the user pick a photo and saves it. Throws a [Failure] when it
  /// cannot be done; the screen shows the message and keeps the profile.
  Future<void> changePhoto() async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    final photoBase64 = await _photoPickerService.pickFromGalleryAsBase64();
    if (photoBase64 == null) return; // the user closed the gallery

    await _profileService.saveProfile(
      _buildUser(currentState.user, photoBase64),
    );
    // No emit needed: the listener in load() receives the saved profile.
  }

  /// Builder pattern again: name and email always come from the account,
  /// only the photo is added when we have one.
  AppUser _buildUser(AppUser account, String? photoBase64) {
    return UserBuilder()
        .setUid(account.uid)
        .setEmail(account.email)
        .setFullName(account.fullName)
        .setPhotoBase64(photoBase64)
        .build();
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}
