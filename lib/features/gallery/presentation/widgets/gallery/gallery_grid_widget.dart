import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:spartapp_test/features/gallery/domain/models/image/gallery_item_model.dart';
import 'package:spartapp_test/features/gallery/presentation/cubit/gallery_cubit.dart';
import 'package:spartapp_test/features/gallery/presentation/widgets/gallery/gallery_grid_item_widget.dart';
import 'package:spartapp_test/routes/app_router.dart';

class GalleryGridWidget extends StatelessWidget {
  const GalleryGridWidget({super.key, required this.images});

  final List<GalleryItemModel> images;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MasonryGridView.count(
        itemCount: images.length,
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        itemBuilder: (context, index) => GalleryGridItemWidget(
          image: images[index],
          onTap: (image) {
            context.read<GalleryCubit>().updateSelectedImage(selectedImage: image);
            context.goNamed(AppRouter.imageDetailRouteData.name);
          },
        ),
      ),
    );
  }
}
