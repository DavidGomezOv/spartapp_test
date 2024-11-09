import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spartapp_test/core/base_datasource/base_api/api_client.dart';
import 'package:spartapp_test/features/gallery/data/datasource/gallery_api.dart';
import 'package:spartapp_test/features/gallery/data/repository/gallery_repository_impl.dart';
import 'package:spartapp_test/features/gallery/domain/repository/gallery_repository.dart';
import 'package:spartapp_test/features/gallery/presentation/cubit/gallery_cubit.dart';
import 'package:spartapp_test/routes/app_router.dart';
import 'package:spartapp_test/theme/custom_colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<GalleryRepository>(
      create: (context) => GalleryRepositoryImpl(
        galleryApi: GalleryApi(
          baseApiClient: ApiClient(),
        ),
      ),
      child: BlocProvider(
        create: (context) => GalleryCubit(
          galleryRepository: context.read<GalleryRepository>(),
        )..fetchGallery(),
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
