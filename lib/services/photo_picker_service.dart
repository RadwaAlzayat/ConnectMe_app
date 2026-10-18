import 'dart:convert';

import 'package:image_picker/image_picker.dart';

import '../core/errors/failures.dart';

/// Lets the user pick a photo from the gallery with image_picker.
class PhotoPickerService {
  PhotoPickerService(this._imagePicker);

  final ImagePicker _imagePicker;

  // The photo is stored INSIDE a Firestore document, which is limited to
  // about 1 MB, so it is shrunk before saving (a 512 px photo is ~50 KB).
  static const double _maxSidePixels = 512;
  static const int _jpegQuality = 70;

  /// Opens the gallery and returns the photo as base64 text, or null when the
  /// user closes the gallery without choosing anything.
  Future<String?> pickFromGalleryAsBase64() async {
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: _maxSidePixels,
        maxHeight: _maxSidePixels,
        imageQuality: _jpegQuality,
      );
      if (photo == null) return null;
      return base64Encode(await photo.readAsBytes());
    } catch (_) {
      throw const Failure('Could not open the gallery. Please try again.');
    }
  }
}
