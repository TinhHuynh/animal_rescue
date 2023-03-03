import 'package:animal_rescue/extensions/context_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/cupertino_sheet.dart';

showImagePicker(BuildContext context, Function(XFile? file) onImagePicked) {
  final ImagePicker picker = ImagePicker();
  showActionSheet(context, context.s.select_photo,
      context.s.please_select_photo_for_avatar, [
    SheetAction(() async {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      onImagePicked.call(image);
    }, context.s.camera),
    SheetAction(() async {
      final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
      onImagePicked.call(photo);
    }, context.s.gallery),
    SheetAction(() {}, context.s.cancel, isDestructiveAction: true)
  ]);
}
