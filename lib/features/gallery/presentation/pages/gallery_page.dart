import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spartapp_test/core/enums.dart';
import 'package:spartapp_test/features/gallery/presentation/cubit/gallery_cubit.dart';
import 'package:spartapp_test/features/gallery/presentation/widgets/base_scaffold_widget.dart';
import 'package:spartapp_test/features/gallery/presentation/widgets/error_screen_widget.dart';
import 'package:spartapp_test/features/gallery/presentation/widgets/gallery_grid_widget.dart';
import 'package:spartapp_test/theme/custom_colors.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      padding: const EdgeInsets.all(16),
      backgroundColor: CustomColors.primary,
      appbarTitle: 'Imgur',
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
            return ErrorScreenWidget(errorMessage: state.errorMessage);
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
                GalleryGridWidget(images: state.images),
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
