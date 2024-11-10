import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:spartapp_test/features/gallery/domain/models/image/gallery_item_model.dart';
import 'package:spartapp_test/theme/custom_colors.dart';

class ImageDetailHeaderWidget extends StatelessWidget {
  const ImageDetailHeaderWidget({super.key, required this.selectedImage});

  final GalleryItemModel selectedImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Icon(Icons.account_circle_rounded, color: Colors.grey, size: 50),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedImage.accountUrl,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CustomColors.greenText,
                    fontSize: 20,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${selectedImage.views.toString()} Views  -  ',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      Jiffy.parseFromDateTime(
                        DateTime.fromMillisecondsSinceEpoch(selectedImage.datetime * 1000),
                      ).fromNow(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                //TODO Add to favorites function
              },
              icon:  Icon(
                Icons.favorite_outline_rounded,
                size: 35,
                color: CustomColors.greenText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          selectedImage.title,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
