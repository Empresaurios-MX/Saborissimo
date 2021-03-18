import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saborissimo/res/palette.dart';
import 'file:///C:/Users/daniel/Documents/AndroidStudio/saborissimo/lib/widgets/sheet/image_selector_bottom_sheet.dart';

class ImageSelectorUtils {
  final double height;
  final double width;
  final int quality;
  final CameraDevice camera;
  final Function cameraListener;
  final Function galleryListener;

  ImageSelectorUtils({
    this.height,
    this.width,
    this.quality,
    this.camera,
    this.cameraListener,
    this.galleryListener,
  });

  void showSelector(context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ImageSelectorBottomSheet(
        theme: Palette.primary,
        cameraLabel: 'Tomar una foto ahora',
        galleryLabel: 'Seleccionar de la galeria',
        cameraAction: () => _fromCamera(),
        galleryAction: () => _fromGallery(),
      ),
    );
  }

  void _fromCamera() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: height,
      maxWidth: width,
      imageQuality: quality,
      preferredCameraDevice: camera != null ? camera : CameraDevice.rear,
    );

    cameraListener(file);
  }

  void _fromGallery() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: height,
      maxWidth: width,
      imageQuality: quality,
    );

    galleryListener(file);
  }
}
