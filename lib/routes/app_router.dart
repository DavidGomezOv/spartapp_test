import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spartapp_test/features/gallery/presentation/pages/gallery_page.dart';
import 'package:spartapp_test/features/gallery/presentation/pages/image_detail_page.dart';
import 'package:spartapp_test/routes/app_route_data.dart';

class AppRouter {
  static final AppRouteData galleryRouteData = AppRouteData(name: 'gallery', path: '/gallery');
  static final AppRouteData imageDetailRouteData = AppRouteData(name: 'detail', path: '/detail');

  static GoRouter generateAppRouter(BuildContext context) => GoRouter(
        initialLocation: galleryRouteData.path,
        routes: [
          GoRoute(
            name: galleryRouteData.name,
            path: galleryRouteData.path,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const GalleryPage(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
            routes: [
              GoRoute(
                name: imageDetailRouteData.name,
                path: imageDetailRouteData.path,
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ImageDetailPage(),
                  transitionDuration: const Duration(milliseconds: 200),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                      FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}
