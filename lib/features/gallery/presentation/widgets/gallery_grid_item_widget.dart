import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spartapp_test/features/gallery/domain/models/image/gallery_item_model.dart';
import 'package:spartapp_test/theme/custom_colors.dart';

class GalleryGridItemWidget extends StatelessWidget {
  const GalleryGridItemWidget({
    super.key,
    required this.image,
    required this.onTap,
  });

  final GalleryItemModel image;
  final Function(GalleryItemModel image) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(image),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 300, minWidth: double.infinity),
              child: FittedBox(
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
                child: CachedNetworkImage(
                  imageUrl: image.images.first.link,
                  maxHeightDiskCache: 350,
                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        color: CustomColors.surface,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(6),
              color: CustomColors.tertiary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    image.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        image.views.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
