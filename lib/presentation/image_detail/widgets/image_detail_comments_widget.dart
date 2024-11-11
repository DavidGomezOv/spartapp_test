import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:spartapp_test/domain/models/image_detail/image_comment_model.dart';
import 'package:spartapp_test/theme/custom_colors.dart';

class ImageDetailCommentsWidget extends StatelessWidget {
  const ImageDetailCommentsWidget({super.key, required this.comments});

  final List<ImageCommentModel> comments;

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${comments.length} Comments',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final currentComment = comments[index];
            return Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: CustomColors.tertiary, width: 2)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Icon(Icons.account_circle_rounded, color: Colors.grey, size: 45),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentComment.author,
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: CustomColors.greenText,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              Jiffy.parseFromDateTime(
                                DateTime.fromMillisecondsSinceEpoch(currentComment.datetime * 1000),
                              ).fromNow(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currentComment.comment,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
