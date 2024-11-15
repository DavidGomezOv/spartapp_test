import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_model.dart';

class ImageDetailImagesList extends StatelessWidget {
  const ImageDetailImagesList({super.key, required this.selectedImage});

  final GalleryItemModel selectedImage;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedImage.images.length,
      itemBuilder: (context, index) {
        final currentImage = selectedImage.images[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: currentImage.link,
                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(20),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 15),
              if (currentImage.description.isNotEmpty)
                Text(
                  currentImage.description,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 20,
                      ),
                ),
            ],
          ),
        );
      },
    );
  }
}
