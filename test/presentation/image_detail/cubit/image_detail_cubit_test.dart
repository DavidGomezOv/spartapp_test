import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_image_model.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_model.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_tag_model.dart';
import 'package:spartapp_test/presentation/image_detail/cubit/image_detail_cubit.dart';

import '../../../mock_data.dart';
import '../../../mock_repository_providers.dart';

void main() {
  late MockFavoritesRepository mockFavoritesRepository;
  late MockImageDetailRepository mockImageDetailRepository;
  late ImageDetailCubit cubit;

  setUp(() {
    mockFavoritesRepository = MockFavoritesRepository();
    mockImageDetailRepository = MockImageDetailRepository();
    cubit = ImageDetailCubit(
      favoritesRepository: mockFavoritesRepository,
      imageDetailRepository: mockImageDetailRepository,
    );
  });

  tearDown(() {
    reset(mockFavoritesRepository);
    reset(mockImageDetailRepository);
  });

  const mockedNonFavoriteGalleryItemModel = GalleryItemModel(
    id: '6',
    title: 'title',
    description: '',
    datetime: 1731264565,
    accountUrl: 'accountUrl',
    views: 16000,
    images: [
      GalleryItemImageModel(
        link: 'link',
        description: 'description',
        type: 'image/jpeg',
      ),
    ],
    tags: [
      GalleryItemTagModel(displayName: 'Tag name', followers: 36000),
    ],
  );

  blocTest<ImageDetailCubit, ImageDetailState>(
    'emit Loading state and default values when initialized',
    build: () => cubit,
    verify: (cubit) {
      expect(cubit.state, const ImageDetailState());
    },
  );

  group('updateSelectedImage', () {
    blocTest<ImageDetailCubit, ImageDetailState>(
      'emit state with GalleryItemModel when updateSelectedImage method called',
      setUp: () {
        when(() => mockFavoritesRepository.getFavorites()).thenAnswer(
          (_) async => const Result.success(data: mockedGalleryList),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.updateSelectedImage(selectedImage: mockedNonFavoriteGalleryItemModel),
      verify: (cubit) {
        expect(
          cubit.state,
          const ImageDetailState(
            selectedImage: mockedNonFavoriteGalleryItemModel,
          ),
        );
      },
    );

    blocTest<ImageDetailCubit, ImageDetailState>(
      'emit state with GalleryItemModel and isImageInFavorites True when updateSelectedImage method called',
      setUp: () {
        when(() => mockFavoritesRepository.getFavorites()).thenAnswer(
          (_) async => const Result.success(data: mockedGalleryList),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.updateSelectedImage(selectedImage: mockedGalleryItemModel),
      verify: (cubit) {
        expect(
          cubit.state,
          const ImageDetailState(
            selectedImage: mockedGalleryItemModel,
            isImageInFavorites: true,
          ),
        );
      },
    );
  });

  group('addFavorite', () {
    blocTest<ImageDetailCubit, ImageDetailState>(
      'emit AddedToFavorites with GalleryItemModel and isImageInFavorites True when addFavorite method called',
      setUp: () {
        when(() => mockFavoritesRepository.getFavorites()).thenAnswer(
          (_) async => const Result.success(data: mockedGalleryList),
        );
        when(
          () => mockFavoritesRepository.addFavorite(
            galleryItemModel: mockedNonFavoriteGalleryItemModel,
          ),
        ).thenAnswer(
          (_) async => const Result.success(data: true),
        );
      },
      build: () => cubit,
      act: (cubit) {
        cubit.updateSelectedImage(selectedImage: mockedNonFavoriteGalleryItemModel);
        cubit.addImageToFavorites();
      },
      verify: (cubit) {
        expect(
          cubit.state,
          const ImageDetailState(
            imageDetailStatus: ImageDetailFavoriteStatus.addedToFavorites,
            selectedImage: mockedNonFavoriteGalleryItemModel,
            isImageInFavorites: true,
          ),
        );
      },
    );

    blocTest<ImageDetailCubit, ImageDetailState>(
      'emit Failed with GalleryItemModel and Error message when addFavorite method called and failed',
      setUp: () {
        when(() => mockFavoritesRepository.getFavorites()).thenAnswer(
          (_) async => const Result.success(data: mockedGalleryList),
        );
        when(
          () => mockFavoritesRepository.addFavorite(
            galleryItemModel: mockedNonFavoriteGalleryItemModel,
          ),
        ).thenAnswer(
          (_) async => Result.failure(error: exception),
        );
      },
      build: () => cubit,
      act: (cubit) {
        cubit.updateSelectedImage(selectedImage: mockedNonFavoriteGalleryItemModel);
        cubit.addImageToFavorites();
      },
      verify: (cubit) {
        expect(
          cubit.state,
          ImageDetailState(
            imageDetailStatus: ImageDetailFavoriteStatus.failed,
            selectedImage: mockedNonFavoriteGalleryItemModel,
            errorMessage: exception.toString(),
          ),
        );
      },
    );
  });

  group('deleteFavorite', () {
    blocTest<ImageDetailCubit, ImageDetailState>(
      'emit DeleteImageFromFavorites with GalleryItemModel and isImageInFavorites False when deleteFavorite method called',
      setUp: () {
        when(() => mockFavoritesRepository.getFavorites()).thenAnswer(
          (_) async => const Result.success(data: mockedGalleryList),
        );
        when(
          () => mockFavoritesRepository.deleteFavorite(id: mockedGalleryItemModel.id),
        ).thenAnswer(
          (_) async => const Result.success(data: true),
        );
      },
      build: () => cubit,
      act: (cubit) {
        cubit.updateSelectedImage(selectedImage: mockedGalleryItemModel);
        cubit.deleteImageFromFavorites();
      },
      verify: (cubit) {
        expect(
          cubit.state,
          const ImageDetailState(
            imageDetailStatus: ImageDetailFavoriteStatus.deletedFromFavorites,
            selectedImage: mockedGalleryItemModel,
            isImageInFavorites: false,
          ),
        );
      },
    );

    blocTest<ImageDetailCubit, ImageDetailState>(
      'emit Failed with GalleryItemModel and Error message when deleteFavorite method called and failed',
      setUp: () {
        when(() => mockFavoritesRepository.getFavorites()).thenAnswer(
          (_) async => const Result.success(data: mockedGalleryList),
        );
        when(
          () => mockFavoritesRepository.deleteFavorite(id: mockedGalleryItemModel.id),
        ).thenAnswer(
          (_) async => Result.failure(error: exception),
        );
      },
      build: () => cubit,
      act: (cubit) {
        cubit.updateSelectedImage(selectedImage: mockedGalleryItemModel);
        cubit.deleteImageFromFavorites();
      },
      verify: (cubit) {
        expect(
          cubit.state,
          ImageDetailState(
            isImageInFavorites: true,
            imageDetailStatus: ImageDetailFavoriteStatus.failed,
            selectedImage: mockedGalleryItemModel,
            errorMessage: exception.toString(),
          ),
        );
      },
    );
  });

  group('description', () {
    blocTest<ImageDetailCubit, ImageDetailState>(
      'emit Loaded with ImageCommentModel list when fetchImageComments method called',
      setUp: () {
        when(() => mockFavoritesRepository.getFavorites()).thenAnswer(
          (_) async => const Result.success(data: mockedGalleryList),
        );
        when(
          () => mockImageDetailRepository.fetchImageComments(
            imageId: mockedNonFavoriteGalleryItemModel.id,
          ),
        ).thenAnswer(
          (_) async => const Result.success(data: mockedCommentsList),
        );
      },
      build: () => cubit,
      act: (cubit) {
        cubit.updateSelectedImage(selectedImage: mockedNonFavoriteGalleryItemModel);
        cubit.fetchImageComments();
      },
      verify: (cubit) {
        expect(
          cubit.state,
          const ImageDetailState(
            imageCommentsStatus: ImageCommentsStatus.loaded,
            imageComments: mockedCommentsList,
            selectedImage: mockedNonFavoriteGalleryItemModel,
          ),
        );
      },
    );

    blocTest<ImageDetailCubit, ImageDetailState>(
      'emit Failed with Error message when fetchImageComments method called and failed',
      setUp: () {
        when(() => mockFavoritesRepository.getFavorites()).thenAnswer(
          (_) async => const Result.success(data: mockedGalleryList),
        );
        when(
          () => mockImageDetailRepository.fetchImageComments(
            imageId: mockedNonFavoriteGalleryItemModel.id,
          ),
        ).thenAnswer(
          (_) async => Result.failure(error: exception),
        );
      },
      build: () => cubit,
      act: (cubit) {
        cubit.updateSelectedImage(selectedImage: mockedNonFavoriteGalleryItemModel);
        cubit.fetchImageComments();
      },
      verify: (cubit) {
        expect(
          cubit.state,
          ImageDetailState(
            imageCommentsStatus: ImageCommentsStatus.failedToLoad,
            selectedImage: mockedNonFavoriteGalleryItemModel,
            errorMessage: exception.toString(),
          ),
        );
      },
    );
  });
}
