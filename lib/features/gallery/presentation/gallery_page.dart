import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:spartapp_test/core/enums.dart';
import 'package:spartapp_test/features/gallery/presentation/cubit/gallery_cubit.dart';
import 'package:spartapp_test/theme/custom_colors.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Imgur',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
      body: BlocConsumer<GalleryCubit, GalleryState>(
        listener: (context, state) {
          if (state.pageStatus == PageStatus.failedToLoad) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: CustomColors.surface,
                  content: Text(
                    state.errorMessage ?? 'Error loading images, please try again later.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.pageStatus == PageStatus.loading && state.images.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: CustomColors.surface),
            );
          }

          if (state.pageStatus == PageStatus.failedToLoad) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_tethering_error_rounded_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                  Text(
                    state.errorMessage ?? 'Error loading images, please try again later.',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels > notification.metrics.maxScrollExtent - 1500 &&
                  state.pageStatus != PageStatus.loading) {
                context.read<GalleryCubit>().fetchGallery();
                return true;
              }
              return false;
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: MasonryGridView.count(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.images.length,
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemBuilder: (context, index) {
                      final image = state.images[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              constraints:
                                  const BoxConstraints(maxHeight: 300, minWidth: double.infinity),
                              child: FittedBox(
                                alignment: Alignment.topCenter,
                                fit: BoxFit.cover,
                                child: CachedNetworkImage(
                                  imageUrl: image.imageData.link,
                                  maxHeightDiskCache: 350,
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      Center(
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
                      );
                    },
                  ),
                ),
                if (state.pageStatus == PageStatus.loading) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      color: CustomColors.surface,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
