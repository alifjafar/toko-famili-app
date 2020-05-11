import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'image_item_loading.dart';
import 'image_preview_item.dart';

class ImageItem extends StatelessWidget {
  final String url;
  final double height;
  final bool topRounded;
  final bool previewImage;
  final List<String> galleryImages;
  final int initialIndex;

  const ImageItem(
      {Key key,
      this.url,
      this.height = 100.00,
      this.topRounded = true,
      this.previewImage = false,
      this.galleryImages,
      this.initialIndex = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return previewImage
        ? GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        (galleryImages.isNotEmpty && galleryImages.length > 1)
                            ? ImagePreviewItem(
                                "preview",
                                initialIndex: initialIndex,
                                galleryItems: galleryImages.isNotEmpty &&
                                        galleryImages.length > 1
                                    ? galleryImages
                                    : Iterable.empty(),
                              )
                            : ImagePreviewItem(
                                "preview",
                                imageUrl: url,
                              ))),
            child: Hero(
              child: imageItem(),
              tag: "preview",
            ),
          )
        : imageItem();
  }

  Widget _defaultImage() {
    return ImageItemLoading(width: double.infinity, height: height);
  }

  Widget imageItem() {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: topRounded
              ? BorderRadius.only(
                  topLeft: Radius.circular(6.0), topRight: Radius.circular(6.0))
              : null,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (BuildContext context, url) => _defaultImage(),
      errorWidget: (context, url, error) => CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => _defaultImage(),
        errorWidget: (context, url, error) => _defaultImage(),
      ),
    );
  }
}
