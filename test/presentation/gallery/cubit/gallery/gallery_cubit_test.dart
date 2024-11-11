import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spartapp_test/core/enums.dart';
import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_image_model.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_model.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_tag_model.dart';
import 'package:spartapp_test/presentation/gallery/cubit/gallery/gallery_cubit.dart';

import '../../../../mock_data.dart';
import '../../../../mock_repository_providers.dart';

void main() {
  late MockGalleryRepository mockGalleryRepository;
  late MockFavoritesRepository mockFavoritesRepository;
  late GalleryCubit cubit;

  setUp(() {
    mockGalleryRepository = MockGalleryRepository();
    mockFavoritesRepository = MockFavoritesRepository();
    cubit = GalleryCubit(
      galleryRepository: mockGalleryRepository,
      favoritesRepository: mockFavoritesRepository,
    );
  });

  tearDown(() {
    reset(mockGalleryRepository);
  });

  blocTest<GalleryCubit, GalleryState>(
    'emit Loading state and default values when initialized',
    build: () => cubit,
    verify: (cubit) {
      expect(cubit.state, const GalleryState());
    },
  );

  group('updateSelectedImage', () {
    final mockedGalleryListWithVideos = [
      ...mockedGalleryList,
      const GalleryItemModel(
        id: '4',
        title: 'title',
        description: '',
        datetime: 1731264565,
        accountUrl: 'accountUrl',
        views: 16000,
        images: [
          GalleryItemImageModel(
            link: 'link',
            description: 'description',
            type: 'video/mpa',
          ),
        ],
        tags: [
          GalleryItemTagModel(displayName: 'Tag name', followers: 36000),
        ],
      ),
    ];

    blocTest<GalleryCubit, GalleryState>(
      'emit Loaded with GalleryItemModel list when updateSearchCriteria method called',
      setUp: () {
        when(
          () =>
              mockGalleryRepository.fetchGalleryBySearch(searchCriteria: 'searchCriteria', page: 1),
        ).thenAnswer(
          (_) async => const Result.success(data: mockedGalleryList),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.updateSearchCriteria(searchCriteria: 'searchCriteria'),
      verify: (cubit) {
        expect(
          cubit.state,
          const GalleryState(
            pageStatus: PageStatus.loaded,
            searchCriteria: 'searchCriteria',
            currentPage: 1,
            images: mockedGalleryList,
          ),
        );
      },
    );

    blocTest<GalleryCubit, GalleryState>(
      'emit Loaded with GalleryItemModel list without videos items when updateSearchCriteria method called',
      setUp: () {
        when(
          () =>
              mockGalleryRepository.fetchGalleryBySearch(searchCriteria: 'searchCriteria', page: 1),
        ).thenAnswer(
          (_) async => Result.success(data: mockedGalleryListWithVideos),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.updateSearchCriteria(searchCriteria: 'searchCriteria'),
      verify: (cubit) {
        expect(
          cubit.state,
          const GalleryState(
            pageStatus: PageStatus.loaded,
            searchCriteria: 'searchCriteria',
            currentPage: 1,
            images: mockedGalleryList,
          ),
        );
      },
    );

    blocTest<GalleryCubit, GalleryState>(
      'emit FailedToLoad with Error message when updateSearchCriteria method called and failed',
      setUp: () {
        when(
          () =>
              mockGalleryRepository.fetchGalleryBySearch(searchCriteria: 'searchCriteria', page: 1),
        ).thenAnswer(
          (_) async => Result.failure(error: exception),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.updateSearchCriteria(searchCriteria: 'searchCriteria'),
      verify: (cubit) {
        expect(
          cubit.state,
          GalleryState(
            pageStatus: PageStatus.failedToLoad,
            errorMessage: exception.toString(),
            searchCriteria: 'searchCriteria',
          ),
        );
      },
    );
  });

  group('fetchGallery', () {
    blocTest<GalleryCubit, GalleryState>(
      'emit Loaded with GalleryItemModel list when fetchGallery method called',
      setUp: () {
        when(
          () => mockGalleryRepository.fetchGallery(page: 1),
        ).thenAnswer(
          (_) async => const Result.success(data: mockedGalleryList),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.fetchGallery(page: 1),
      verify: (cubit) {
        expect(
          cubit.state,
          const GalleryState(
            pageStatus: PageStatus.loaded,
            currentPage: 1,
            images: mockedGalleryList,
          ),
        );
      },
    );

    blocTest<GalleryCubit, GalleryState>(
      'emit Loaded with GalleryItemModel list from fetchGalleryBySearch when fetchGallery method called and searchCriteria value exists',
      setUp: () {
        when(
          () =>
              mockGalleryRepository.fetchGalleryBySearch(searchCriteria: 'searchCriteria', page: 1),
        ).thenAnswer(
          (_) async => const Result.success(data: mockedGalleryList),
        );
      },
      build: () => cubit,
      seed: () => const GalleryState(searchCriteria: 'searchCriteria'),
      act: (cubit) => cubit.fetchGallery(page: 1),
      verify: (cubit) {
        expect(
          cubit.state,
          const GalleryState(
            searchCriteria: 'searchCriteria',
            pageStatus: PageStatus.loaded,
            currentPage: 1,
            images: mockedGalleryList,
          ),
        );
      },
    );

    blocTest<GalleryCubit, GalleryState>(
      'emit FailedToLoad with Error message when fetchGallery method called and failed',
      setUp: () {
        when(
          () => mockGalleryRepository.fetchGallery(page: 1),
        ).thenAnswer(
          (_) async => Result.failure(error: exception),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.fetchGallery(page: 1),
      verify: (cubit) {
        expect(
          cubit.state,
          GalleryState(
            pageStatus: PageStatus.failedToLoad,
            errorMessage: exception.toString(),
          ),
        );
      },
    );
  });

  group('getFavorites', () {
    blocTest<GalleryCubit, GalleryState>(
      'emit Loaded with GalleryItemModel list when getFavorites method called',
      setUp: () {
        when(
          () => mockFavoritesRepository.getFavorites(),
        ).thenAnswer(
          (_) async => const Result.success(data: mockedGalleryList),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.getFavorites(),
      verify: (cubit) {
        expect(
          cubit.state,
          const GalleryState(
            pageStatus: PageStatus.loaded,
            images: mockedGalleryList,
          ),
        );
      },
    );

    blocTest<GalleryCubit, GalleryState>(
      'emit FailedToLoad with Error message when getFavorites method called and failed',
      setUp: () {
        when(
          () => mockFavoritesRepository.getFavorites(),
        ).thenAnswer(
          (_) async => Result.failure(error: exception),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.getFavorites(),
      verify: (cubit) {
        expect(
          cubit.state,
          GalleryState(
            pageStatus: PageStatus.failedToLoad,
            errorMessage: exception.toString(),
          ),
        );
      },
    );
  });

  group('updateShowFavorites', () {
    blocTest<GalleryCubit, GalleryState>(
      'emit Loaded with GalleryItemModel list from getFavorites method when updateShowFavorites method called',
      setUp: () {
        when(
          () => mockFavoritesRepository.getFavorites(),
        ).thenAnswer(
          (_) async => const Result.success(data: mockedGalleryList),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.updateShowFavorites(),
      verify: (cubit) {
        expect(
          cubit.state,
          const GalleryState(
            showingFavorites: true,
            pageStatus: PageStatus.loaded,
            images: mockedGalleryList,
          ),
        );
      },
    );

    blocTest<GalleryCubit, GalleryState>(
      'emit Loaded with GalleryItemModel list from fetchGallery method when updateShowFavorites method called',
      setUp: () {
        when(
          () => mockGalleryRepository.fetchGallery(page: 1),
        ).thenAnswer(
          (_) async => const Result.success(data: mockedGalleryList),
        );
      },
      build: () => cubit,
      seed: () => const GalleryState(showingFavorites: true),
      act: (cubit) => cubit.updateShowFavorites(),
      verify: (cubit) {
        expect(
          cubit.state,
          const GalleryState(
            showingFavorites: false,
            currentPage: 1,
            pageStatus: PageStatus.loaded,
            images: mockedGalleryList,
          ),
        );
      },
    );
  });
}
