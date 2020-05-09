import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'app_bar.dart';
import 'image_dots_indicator.dart';
import 'image_item_loading.dart';

class ImagePreviewItem extends StatefulWidget {
  final String heroTag;
  final String imageUrl;
  final List<String> galleryItems;
  final int initialIndex;
  final PageController pageController;

  ImagePreviewItem(this.heroTag,
      {this.imageUrl, this.galleryItems, this.initialIndex})
      : pageController = PageController(initialPage: initialIndex ?? 0);

  @override
  _ImagePreviewItem createState() => _ImagePreviewItem();
}

class _ImagePreviewItem extends State<ImagePreviewItem> {
  int currentIndex;
  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  @override
  initState() {
    if (widget.initialIndex != null) {
      currentIndex = widget.initialIndex;
    }

    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget buildContent() {
    return Container(
      color: Colors.white,
      child: widget.imageUrl == null
          ? _buildPhotoViewGallery()
          : PhotoView(
              imageProvider:
                  NetworkImage(widget.imageUrl),
              loadingBuilder: (context, progress) => ImageItemLoading(),
              backgroundDecoration: BoxDecoration(color: Colors.white),
              heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTag),
              onTapUp: (context, tapDetail, controller) {
                Navigator.of(context).pop();
              },
            ),
    );
  }

  Widget _buildPhotoViewGallery() {
    return Stack(children: <Widget>[
      PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider:
                NetworkImage(widget.galleryItems[index]),
            heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTag),
            onTapUp: (context, tapDetail, controller) {
              Navigator.of(context).pop();
            },
          );
        },
        itemCount: widget.galleryItems.length,
        backgroundDecoration: BoxDecoration(color: Colors.white),
        pageController: widget.pageController,
        loadingBuilder: (context, progress) => ImageItemLoading(),
        onPageChanged: onPageChanged,
        scrollDirection: Axis.horizontal,
      ),
      widget.galleryItems.length > 1
          ? Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(25.0),
                child: Center(
                  child: ImageDotsIndicator(
                    controller: widget.pageController,
                    itemCount: widget.galleryItems.length,
                    color: Colors.grey[500],
                    onPageSelected: (int page) {
                      widget.pageController.animateToPage(
                        page,
                        duration: _kDuration,
                        curve: _kCurve,
                      );
                    },
                  ),
                ),
              ),
            )
          : Container(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBarMV.transparent(),
        body: buildContent());
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
}
