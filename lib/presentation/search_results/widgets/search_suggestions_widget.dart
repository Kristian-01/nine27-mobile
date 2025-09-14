import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SearchSuggestionsWidget extends StatelessWidget {
  final String query;
  final List<String> suggestions;
  final Function(String) onSuggestionTap;
  final VoidCallback? onClearHistory;

  const SearchSuggestionsWidget({
    super.key,
    required this.query,
    required this.suggestions,
    required this.onSuggestionTap,
    this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildSuggestionsList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Text(
            query.isEmpty ? 'Recent Searches' : 'Suggestions',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          const Spacer(),
          if (query.isEmpty && onClearHistory != null)
            TextButton(
              onPressed: onClearHistory,
              child: Text(
                'Clear',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: suggestions.length > 8 ? 8 : suggestions.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
      ),
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return _buildSuggestionItem(suggestion);
      },
    );
  }

  Widget _buildSuggestionItem(String suggestion) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      leading: CustomIconWidget(
        iconName: query.isEmpty ? 'history' : 'search',
        color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5),
        size: 20,
      ),
      title: _buildHighlightedText(suggestion),
      trailing: query.isEmpty
          ? CustomIconWidget(
              iconName: 'north_west',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.3),
              size: 16,
            )
          : null,
      onTap: () => onSuggestionTap(suggestion),
    );
  }

  Widget _buildHighlightedText(String suggestion) {
    if (query.isEmpty) {
      return Text(
        suggestion,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final lowerSuggestion = suggestion.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerSuggestion.indexOf(lowerQuery);

    if (index == -1) {
      return Text(
        suggestion,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return RichText(
      text: TextSpan(
        style: AppTheme.lightTheme.textTheme.bodyMedium,
        children: [
          TextSpan(text: suggestion.substring(0, index)),
          TextSpan(
            text: suggestion.substring(index, index + query.length),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          TextSpan(text: suggestion.substring(index + query.length)),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.3),
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No recent searches',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
