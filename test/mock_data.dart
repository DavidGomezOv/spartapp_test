import 'package:spartapp_test/data/models/gallery/gallery_item_local_image_model.dart';
import 'package:spartapp_test/data/models/gallery/gallery_item_local_model.dart';
import 'package:spartapp_test/data/models/search_history/search_history_item_local_model.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_image_model.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_model.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_tag_model.dart';
import 'package:spartapp_test/domain/models/search_history/search_history_item_model.dart';

const mockedGalleryItemModel = GalleryItemModel(
  id: '1',
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

const mockedGalleryList = [
  GalleryItemModel(
    id: '1',
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
  ),
  GalleryItemModel(
    id: '2',
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
  ),
  GalleryItemModel(
    id: '3',
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
  ),
];

final mockedGalleyItemLocalModel = GalleryItemLocalModel(
  id: '1',
  title: 'title',
  description: '',
  datetime: 1731264565,
  accountUrl: 'accountUrl',
  views: 16000,
  images: [
    GalleryItemLocalImageModel(
      link: 'link',
      description: 'description',
      type: 'image/jpeg',
    ),
  ],
);

final mockedFavoritesList = [
  GalleryItemLocalModel(
    id: '1',
    title: 'title',
    description: '',
    datetime: 1731264565,
    accountUrl: 'accountUrl',
    views: 16000,
    images: [
      GalleryItemLocalImageModel(
        link: 'link',
        description: 'description',
        type: 'image/jpeg',
      ),
    ],
  ),
  GalleryItemLocalModel(
    id: '2',
    title: 'title',
    description: '',
    datetime: 1731264565,
    accountUrl: 'accountUrl',
    views: 16000,
    images: [
      GalleryItemLocalImageModel(
        link: 'link',
        description: 'description',
        type: 'image/jpeg',
      ),
    ],
  ),
  GalleryItemLocalModel(
    id: '3',
    title: 'title',
    description: '',
    datetime: 1731264565,
    accountUrl: 'accountUrl',
    views: 16000,
    images: [
      GalleryItemLocalImageModel(
        link: 'link',
        description: 'description',
        type: 'image/jpeg',
      ),
    ],
  ),
];

final mockedSearchHistoryItemLocalModel =
    SearchHistoryItemLocalModel(searchCriteria: 'searchCriteria');

const mockedSearchHistoryItemModel = SearchHistoryItemModel(searchCriteria: 'searchCriteria');

final mockedSearchHistoryModelList = [
  SearchHistoryItemLocalModel(searchCriteria: 'searchCriteria'),
  SearchHistoryItemLocalModel(searchCriteria: 'searchCriteria'),
  SearchHistoryItemLocalModel(searchCriteria: 'searchCriteria'),
];

const mockedSearchHistoryList = [
  SearchHistoryItemModel(searchCriteria: 'searchCriteria'),
  SearchHistoryItemModel(searchCriteria: 'searchCriteria'),
  SearchHistoryItemModel(searchCriteria: 'searchCriteria'),
];
