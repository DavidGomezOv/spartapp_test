import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:spartapp_test/features/gallery/domain/models/image/gallery_item_model.dart';
import 'package:spartapp_test/features/gallery/domain/repository/gallery_repository.dart';
import 'package:spartapp_test/features/gallery/presentation/cubit/gallery_cubit.dart';
import 'package:spartapp_test/theme/custom_colors.dart';
import 'package:collection/collection.dart';

class ImageDetailHeaderWidget extends StatelessWidget {
  const ImageDetailHeaderWidget({super.key, required this.selectedImage});

  final GalleryItemModel selectedImage;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isImageFavorite = ValueNotifier<bool>(false);
    _checkImageFavorite(context).then((value) => isImageFavorite.value = value);
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
              onPressed: () async {
                if (isImageFavorite.value) {
                  await context.read<GalleryRepository>().deleteFavorite(id: selectedImage.id);
                } else {
                  await context
                      .read<GalleryRepository>()
                      .addFavorite(galleryItemModel: selectedImage);
                }
                if (!context.mounted) return;
                _checkImageFavorite(context).then(
                  (value) {
                    if (!context.mounted) return;
                    final galleryCubit = context.read<GalleryCubit>();
                    if (galleryCubit.state.showingFavorites) {
                      galleryCubit.getFavorites();
                    }
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 5),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: CustomColors.surface,
                          content: Text(
                            value ? 'Added to favorites' : 'Removed from favorites',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    isImageFavorite.value = value;
                  },
                );
              },
              icon: ValueListenableBuilder(
                valueListenable: isImageFavorite,
                builder: (_, value, __) => Icon(
                  value ? Icons.favorite_outlined : Icons.favorite_outline_rounded,
                  size: 35,
                  color: CustomColors.greenText,
                ),
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

  Future<bool> _checkImageFavorite(BuildContext context) async {
    final result = await context.read<GalleryRepository>().getFavorites();
    return result.when(
      success: (images) {
        final data = images.firstWhereOrNull(
          (element) => element.id == selectedImage.id,
        );
        return data != null;
      },
      failure: (error) => false,
    );
  }
}
