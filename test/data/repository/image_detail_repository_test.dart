import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spartapp_test/data/datasource/image_detail_api.dart';
import 'package:spartapp_test/data/repository/image_detail_repository_impl.dart';
import 'package:spartapp_test/domain/models/image_detail/image_comment_model.dart';

import '../../mock_data.dart';
import 'image_detail_repository_test.mocks.dart';

void _verifyListData({
  required List<ImageCommentModel> responseList,
  required List<ImageCommentModel> mockedList,
}) {
  expect(responseList.length, mockedList.length);
  mockedList.forEachIndexed(
    (index, element) {
      expect(responseList[index].author, element.author);
      expect(responseList[index].comment, element.comment);
      expect(responseList[index].datetime, element.datetime);
    },
  );
}

@GenerateNiceMocks([MockSpec<ImageDetailApi>()])
void main() {
  final MockImageDetailApi mockImageDetailApi = MockImageDetailApi();

  late ImageDetailRepositoryImpl imageDetailRepositoryImpl;

  setUp(() {
    imageDetailRepositoryImpl = ImageDetailRepositoryImpl(imageDetailApi: mockImageDetailApi);
  });

  tearDown(() {
    clearInteractions(mockImageDetailApi);
  });

  group('ImageDetailRepository - fetchImageComments', () {
    test('Given a successfully API response should return Success with ImageCommentModel list',
        () async {
      when(mockImageDetailApi.fetchImageComments(imageId: '1')).thenAnswer(
        (_) async => mockedCommentsList,
      );

      final result = await imageDetailRepositoryImpl.fetchImageComments(imageId: '1');

      verify(mockImageDetailApi.fetchImageComments(imageId: '1')).called(1);

      result.when(
        success: (data) => _verifyListData(responseList: data, mockedList: mockedCommentsList),
        failure: (error) => expect(true, false, reason: 'Should have succeeded'),
      );
    });

    test('Given a unsuccessfully API response should return Failure', () async {
      when(mockImageDetailApi.fetchImageComments(imageId: '1')).thenThrow(badRequestError);

      final result = await imageDetailRepositoryImpl.fetchImageComments(imageId: '1');

      verify(mockImageDetailApi.fetchImageComments(imageId: '1')).called(1);

      result.when(
        success: (data) => expect(true, false, reason: 'Should have failed'),
        failure: (error) => expect(
          error,
          isInstanceOf<Exception>(),
          reason: 'Should fail with Exception',
        ),
      );
    });
  });
}
