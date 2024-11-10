import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spartapp_test/core/base_datasource/base_api/api_client.dart';
import 'package:spartapp_test/data/datasource/gallery_api.dart';
import 'package:spartapp_test/data/datasource/gallery_local.dart';
import 'package:spartapp_test/data/repository/favorites_repository_impl.dart';
import 'package:spartapp_test/data/repository/gallery_repository_impl.dart';
import 'package:spartapp_test/domain/repository/favorites_repository.dart';
import 'package:spartapp_test/domain/repository/gallery_repository.dart';
import 'package:spartapp_test/presentation/gallery/cubit/gallery_cubit.dart';
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
        RepositoryProvider<FavoritesRepository>(
          create: (context) => FavoritesRepositoryImpl(
            galleryLocal: GalleryLocal(),
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
