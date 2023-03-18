import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../gen/colors.gen.dart';
import '../../../../application/case/create_case/create_case_cubit.dart';
import '../../../../domain/case/value_objects/value_object.dart';
import '../../../core/dialogs/image_picker.dart';

class PhotoList extends StatefulWidget {
  const PhotoList(
      {Key? key, required this.onPhotoAdded, required this.onPhotoRemoved})
      : super(key: key);
  final Function(List<CaseLocalPhoto> list, CaseLocalPhoto added) onPhotoAdded;
  final Function(List<CaseLocalPhoto> list, CaseLocalPhoto removed)
      onPhotoRemoved;

  @override
  State<PhotoList> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  final List<CaseLocalPhoto> photos = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _addPhoto(context),
          ..._photoList(),
        ],
      ),
    );
  }

  _addPhoto(BuildContext context) {
    return BlocBuilder<CreateCaseCubit, CreateCaseState>(
      buildWhen: (_, state) => state.maybeWhen(
          orElse: () => false,
          submitting: () => true,
          submitFailed: (e) => e.maybeWhen(
              orElse: () => false,
              invalidPhoto: () => true,
              missingPhoto: () => true,
              moreThan3Photos: () => true)),
      builder: (context, state) {
        final color = photos.length == 3
            ? Colors.grey
            : state.maybeWhen(
                orElse: () => ColorName.brand, submitFailed: (e) => Colors.red);
        return GestureDetector(
          onTap: () => photos.length == 3 ? null : _openImagePicker(context),
          child: DottedBorder(
            color: color,
            strokeWidth: 2,
            child: SizedBox(
              width: 150,
              height: 150,
              child: Icon(
                Icons.add_a_photo,
                size: 75,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _photoList() {
    return photos.isEmpty
        ? [
            const SizedBox(
              width: 150,
              height: 150,
            )
          ]
        : photos.map((e) => _photo(context, e)).toList();
  }

  Widget _photo(BuildContext context, CaseLocalPhoto photo) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Stack(
        children: [
          Image.file(File(photo.getOrCrash()),
              width: 150, height: 150, fit: BoxFit.cover),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  photos.remove(photo);
                });
                widget.onPhotoRemoved(photos, photo);
              },
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.delete_forever,
                  color: ColorName.brand,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _openImagePicker(BuildContext context) {
    showImagePicker(context, (file) {
      if (file != null) {
        final added = CaseLocalPhoto(file.path);
        setState(() {
          photos.add(added);
        });
        widget.onPhotoAdded(photos, added);
      }
    });
  }
}
