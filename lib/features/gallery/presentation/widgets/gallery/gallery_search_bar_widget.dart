import 'package:flutter/material.dart';
import 'package:spartapp_test/theme/custom_colors.dart';

class GallerySearchBarWidget extends StatefulWidget {
  const GallerySearchBarWidget({
    super.key,
    required this.onSearchTriggered,
  });

  final Function(String? searchCriteria) onSearchTriggered;

  @override
  State<GallerySearchBarWidget> createState() => _GallerySearchBarWidgetState();
}

class _GallerySearchBarWidgetState extends State<GallerySearchBarWidget> {
  final SearchController _searchController = SearchController();
  final FocusNode _focusNode = FocusNode();

  static const defaultSearchSuggestions = [
    'Cats',
    'Mountains',
    'Books',
    'Tech',
    'Movies',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      viewShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      isFullScreen: false,
      dividerColor: Colors.white,
      viewConstraints: const BoxConstraints(
        minHeight: 100,
        maxHeight: 300,
      ),
      headerTextStyle: Theme.of(context).textTheme.titleLarge,
      viewOnSubmitted: (value) {
        _searchController.closeView(value);
        _focusNode.unfocus();
        widget.onSearchTriggered(value);
      },
      viewBackgroundColor: CustomColors.secondary,
      viewLeading: IconButton(
        onPressed: () {
          _searchController.closeView(null);
          _focusNode.unfocus();
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
      ),
      viewTrailing: [
        IconButton(
          onPressed: () {
            _searchController.closeView('');
            _focusNode.unfocus();
            widget.onSearchTriggered(null);
          },
          icon: const Icon(Icons.close_rounded, color: Colors.white),
        ),
      ],
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          focusNode: _focusNode,
          hintText: 'Search images here...',
          hintStyle: WidgetStatePropertyAll(
            Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white60),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.titleLarge),
          backgroundColor: WidgetStatePropertyAll(CustomColors.secondary),
          controller: controller,
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16.0)),
          leading: const Icon(Icons.search, color: Colors.white),
          onTap: () => controller.openView(),
          onChanged: (value) {
            controller.openView();
          },
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return defaultSearchSuggestions.map(
          (element) => ListTile(
            title: Text(
              element,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onTap: () {
              controller.closeView(element);
              _focusNode.unfocus();
              widget.onSearchTriggered(element);
            },
            contentPadding: const EdgeInsets.only(left: 20),
            trailing: IconButton(
              onPressed: () {
                //TODO Remove from recent searches
              },
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
