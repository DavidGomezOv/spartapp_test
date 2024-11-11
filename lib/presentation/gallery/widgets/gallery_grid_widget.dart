import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_model.dart';
import 'package:spartapp_test/presentation/gallery/widgets/gallery_grid_item_widget.dart';
import 'package:spartapp_test/presentation/image_detail/cubit/image_detail_cubit.dart';
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
            context.read<ImageDetailCubit>()
              ..updateSelectedImage(selectedImage: image)
              ..fetchImageComments();
            context.goNamed(AppRouter.imageDetailRouteData.name);
          },
        ),
      ),
    );
  }
}
