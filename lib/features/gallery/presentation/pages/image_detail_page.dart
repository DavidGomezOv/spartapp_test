import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spartapp_test/features/gallery/presentation/cubit/gallery_cubit.dart';
import 'package:spartapp_test/features/gallery/presentation/widgets/base_scaffold_widget.dart';
import 'package:spartapp_test/features/gallery/presentation/widgets/image_detail_comments_widget.dart';
import 'package:spartapp_test/features/gallery/presentation/widgets/image_detail_header_widget.dart';
import 'package:spartapp_test/features/gallery/presentation/widgets/image_detail_images_list.dart';

class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedImage = context.read<GalleryCubit>().state.selectedImage;
    if (selectedImage == null) return const SizedBox.shrink();
    return BaseScaffoldWidget(
      padding: const EdgeInsets.all(16),
      appbarTitle: 'Imgur',
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageDetailHeaderWidget(selectedImage: selectedImage),
            const SizedBox(height: 12),
            ImageDetailImagesList(selectedImage: selectedImage),
            const SizedBox(height: 12),
            const ImageDetailCommentsWidget(),
          ],
        ),
      ),
    );
  }
}
