import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spartapp_test/core/base_datasource/base_api/api_client.dart';
import 'package:spartapp_test/data/datasource/gallery_api.dart';
import 'package:spartapp_test/data/datasource/favorites_local_source.dart';
import 'package:spartapp_test/data/datasource/image_detail_api.dart';
import 'package:spartapp_test/data/datasource/search_history_local_source.dart';
import 'package:spartapp_test/data/repository/favorites_repository_impl.dart';
import 'package:spartapp_test/data/repository/gallery_repository_impl.dart';
import 'package:spartapp_test/data/repository/image_detail_repository_impl.dart';
import 'package:spartapp_test/data/repository/search_history_repository_impl.dart';
import 'package:spartapp_test/domain/repository/favorites_repository.dart';
import 'package:spartapp_test/domain/repository/gallery_repository.dart';
import 'package:spartapp_test/domain/repository/image_detail_repository.dart';
import 'package:spartapp_test/domain/repository/search_history_repository.dart';
import 'package:spartapp_test/presentation/gallery/cubit/gallery/gallery_cubit.dart';
import 'package:spartapp_test/presentation/gallery/cubit/search_history/search_history_cubit.dart';
import 'package:spartapp_test/presentation/image_detail/cubit/image_detail_cubit.dart';
import 'package:spartapp_test/routes/app_router.dart';
import 'package:spartapp_test/theme/custom_colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GalleryRepository>(
          create: (context) => GalleryRepositoryImpl(
            galleryApi: GalleryApi(
              baseApiClient: ApiClient(),
            ),
          ),
        ),
        RepositoryProvider<ImageDetailRepository>(
          create: (context) => ImageDetailRepositoryImpl(
            imageDetailApi: ImageDetailApi(
              baseApiClient: ApiClient(),
            ),
          ),
        ),
        RepositoryProvider<FavoritesRepository>(
          create: (context) => FavoritesRepositoryImpl(
            favoritesLocalSource: FavoritesLocalSource(),
          ),
        ),
        RepositoryProvider<SearchHistoryRepository>(
          create: (context) => SearchHistoryRepositoryImpl(
            searchHistoryLocalSource: SearchHistoryLocalSource(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GalleryCubit>(
            create: (context) => GalleryCubit(
              galleryRepository: context.read<GalleryRepository>(),
              favoritesRepository: context.read<FavoritesRepository>(),
            )..fetchGallery(),
          ),
          BlocProvider<ImageDetailCubit>(
            create: (context) => ImageDetailCubit(
              favoritesRepository: context.read<FavoritesRepository>(),
              imageDetailRepository: context.read<ImageDetailRepository>(),
            ),
          ),
          BlocProvider<SearchHistoryCubit>(
            create: (context) => SearchHistoryCubit(
              searchHistoryRepository: context.read<SearchHistoryRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: AppRouter.generateAppRouter(context),
          theme: ThemeData(
            primaryColor: CustomColors.primary,
            colorScheme: ColorScheme.light(
              primary: CustomColors.primary,
              secondary: CustomColors.secondary,
              tertiary: CustomColors.tertiary,
              surface: CustomColors.surface,
            ),
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
