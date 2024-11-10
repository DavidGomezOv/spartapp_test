import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spartapp_test/core/enums.dart';
import 'package:spartapp_test/presentation/gallery/cubit/gallery_cubit.dart';
import 'package:spartapp_test/presentation/widgets/base_scaffold_widget.dart';
import 'package:spartapp_test/presentation/widgets/error_screen_widget.dart';
import 'package:spartapp_test/presentation/gallery/widgets/gallery_grid_widget.dart';
import 'package:spartapp_test/presentation/gallery/widgets/gallery_search_bar_widget.dart';
import 'package:spartapp_test/theme/custom_colors.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      padding: const EdgeInsets.all(16),
      backgroundColor: CustomColors.primary,
      appbarTitle: 'Imgur',
      floatingActionButton: BlocBuilder<GalleryCubit, GalleryState>(
        buildWhen: (previous, current) => previous.showingFavorites != current.showingFavorites,
        builder: (context, state) {
          return FloatingActionButton(
            backgroundColor: CustomColors.greenText,
            onPressed: () => context.read<GalleryCubit>().updateShowFavorites(),
            child: Icon(
              state.showingFavorites ? Icons.manage_search_outlined : Icons.favorite_outlined,
              size: 30,
              color: CustomColors.surface,
            ),
          );
        },
      ),
      body: Column(
        children: [
          BlocBuilder<GalleryCubit, GalleryState>(
            buildWhen: (previous, current) => previous.showingFavorites != current.showingFavorites,
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.showingFavorites)
                    Text(
                      'Favorites',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    )
                  else
                    TapRegion(
                      onTapOutside: (event) => FocusScope.of(context).requestFocus(FocusNode()),
                      child: GallerySearchBarWidget(
                        onSearchTriggered: (searchCriteria) =>
                            context.read<GalleryCubit>().updateSearchCriteria(
                                  searchCriteria: searchCriteria,
                                ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
          Expanded(
            child: BlocConsumer<GalleryCubit, GalleryState>(
              listener: (context, state) {
                if (state.pageStatus == PageStatus.failedToLoad) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 5),
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
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (state.pageStatus == PageStatus.failedToLoad) {
                  return ErrorScreenWidget(errorMessage: state.errorMessage);
                }

                if (state.images.isEmpty) {
                  return Center(
                    child: Text(
                      state.showingFavorites
                          ? 'You don\'t have favorites yet, try adding one first...'
                          : 'No images available',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return NotificationListener<ScrollEndNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels > notification.metrics.maxScrollExtent - 1500 &&
                        state.pageStatus != PageStatus.loading &&
                        !state.showingFavorites) {
                      context.read<GalleryCubit>().fetchGallery();
                      return true;
                    }
                    return false;
                  },
                  child: Column(
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
          ),
        ],
      ),
    );
  }
}
