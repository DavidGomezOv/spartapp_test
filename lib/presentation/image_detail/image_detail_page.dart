import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spartapp_test/presentation/gallery/cubit/gallery/gallery_cubit.dart';
import 'package:spartapp_test/presentation/image_detail/cubit/image_detail_cubit.dart';
import 'package:spartapp_test/presentation/image_detail/widgets/image_detail_images_list.dart';
import 'package:spartapp_test/presentation/widgets/base_scaffold_widget.dart';
import 'package:spartapp_test/presentation/image_detail/widgets/image_detail_comments_widget.dart';
import 'package:spartapp_test/presentation/image_detail/widgets/image_detail_header_widget.dart';
import 'package:spartapp_test/theme/custom_colors.dart';

class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      padding: const EdgeInsets.all(16),
      appbarTitle: 'Imgur',
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
      ),
      body: BlocConsumer<ImageDetailCubit, ImageDetailState>(
        listener: (context, state) {
          if (state.imageDetailStatus == ImageDetailFavoriteStatus.addedToFavorites ||
              state.imageDetailStatus == ImageDetailFavoriteStatus.deletedFromFavorites) {
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
                    state.imageDetailStatus == ImageDetailFavoriteStatus.addedToFavorites
                        ? 'Added to favorites'
                        : 'Removed from favorites',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
          } else if (state.imageDetailStatus == ImageDetailFavoriteStatus.failed ||
              state.imageCommentsStatus == ImageCommentsStatus.failedToLoad) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 5),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: CustomColors.surface,
                  content: Text(
                    state.errorMessage ?? 'An error occurred, please try again later',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.selectedImage == null) return const SizedBox.shrink();
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageDetailHeaderWidget(selectedImage: state.selectedImage!),
                const SizedBox(height: 12),
                ImageDetailImagesList(selectedImage: state.selectedImage!),
                ImageDetailCommentsWidget(comments: state.imageComments),
              ],
            ),
          );
        },
      ),
    );
  }
}
