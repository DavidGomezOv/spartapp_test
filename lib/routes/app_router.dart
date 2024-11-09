import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spartapp_test/features/gallery/presentation/gallery_page.dart';
import 'package:spartapp_test/routes/app_route_data.dart';

class AppRouter {
  static final AppRouteData homeRouteData = AppRouteData(name: 'home', path: '/home');

  static GoRouter generateAppRouter(BuildContext context) => GoRouter(
        initialLocation: homeRouteData.path,
        routes: [
          GoRoute(
            name: homeRouteData.name,
            path: homeRouteData.path,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const GalleryPage(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
          ),
        ],
      );
}
