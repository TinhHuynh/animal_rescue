import 'package:animal_rescue/extensions/context_x.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int currentPos = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_slider(), _countIndicator(currentPos)],
    );
  }

  _countIndicator(int currentPos) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white60,
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text('$currentPos/${widget.imageUrls.length}'),
      ),
    );
  }

  _slider() {
    return CarouselSlider(
      options: CarouselOptions(
          viewportFraction: 1,
          height: 300,
          enableInfiniteScroll: false,
          onPageChanged: (index, _) {
            setState(() {
              currentPos = index + 1;
            });
          }),
      items: widget.imageUrls.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return SizedBox(
              width: context.mediaQuery.size.width,
              child: Image.network(
                i,
                fit: BoxFit.cover,
                loadingBuilder: (ctx, widget, evt) {
                  if (evt == null) return widget;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
