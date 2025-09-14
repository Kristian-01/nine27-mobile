import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;
  final List<String> suggestions;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
    required this.suggestions,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  bool _showSuggestions = false;
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    final query = widget.controller.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _showSuggestions = false;
        _filteredSuggestions = [];
      });
    } else {
      setState(() {
        _filteredSuggestions = widget.suggestions
            .where((suggestion) => suggestion.toLowerCase().contains(query))
            .take(5)
            .toList();
        _showSuggestions = _filteredSuggestions.isNotEmpty;
      });
    }
    widget.onChanged(widget.controller.text);
  }

  void _selectSuggestion(String suggestion) {
    widget.controller.text = suggestion;
    setState(() {
      _showSuggestions = false;
    });
    widget.onChanged(suggestion);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: 'Search medicines, vitamins, supplements...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'search',
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  onTap: () {
                    if (widget.controller.text.isNotEmpty &&
                        _filteredSuggestions.isNotEmpty) {
                      setState(() {
                        _showSuggestions = true;
                      });
                    }
                  },
                ),
              ),
              Container(
                width: 1,
                height: 5.h,
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
              InkWell(
                onTap: widget.onFilterTap,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'tune',
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showSuggestions) _buildSuggestionsList(context),
      ],
    );
  }

  Widget _buildSuggestionsList(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: _filteredSuggestions.map((suggestion) {
          final isLast = _filteredSuggestions.last == suggestion;
          return InkWell(
            onTap: () => _selectSuggestion(suggestion),
            borderRadius: BorderRadius.circular(isLast ? 12 : 0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                border: !isLast
                    ? Border(
                        bottom: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'search',
                    color: colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      suggestion,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'north_west',
                    color: colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
