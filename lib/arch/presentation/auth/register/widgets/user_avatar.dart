import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../core/dialogs/image_picker.dart';

class UserAvatarWidget extends StatefulWidget {
  final Function(String? path) onImagePathChanged;

  const UserAvatarWidget({Key? key, required this.onImagePathChanged})
      : super(key: key);

  @override
  State<UserAvatarWidget> createState() => _UserAvatarWidgetState();
}

class _UserAvatarWidgetState extends State<UserAvatarWidget> {
  String? filePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => _openPhotoDialog(context),
        child: Stack(
          children: [
            (filePath == null || filePath!.isEmpty)
                ? Assets.images.imgUserAvatar.image(width: 150, height: 150)
                : SizedBox(
                    width: 150,
                    height: 150,
                    child: CircleAvatar(
                      backgroundImage: FileImage(File(filePath!)),
                    ),
                  ),
            const Positioned(
                bottom: 0,
                right: 10,
                child: Icon(
                  Icons.add_a_photo,
                  color: ColorName.brand,
                ))
          ],
        ),
      ),
    );
  }

  _openPhotoDialog(BuildContext context) {
    showImagePicker(context, (file) {
      setState(() {
        filePath = file?.path;
      });
      widget.onImagePathChanged.call(file?.path);
    });
  }
}
