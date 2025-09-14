import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class EmptySearchState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onSearchSuggestionTap;

  const EmptySearchState({
    super.key,
    required this.searchQuery,
    this.onSearchSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          _buildEmptyIcon(),
          SizedBox(height: 3.h),
          _buildEmptyMessage(),
          SizedBox(height: 4.h),
          _buildSuggestions(),
          SizedBox(height: 4.h),
          _buildPopularMedicines(),
        ],
      ),
    );
  }

  Widget _buildEmptyIcon() {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'search_off',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 48,
        ),
      ),
    );
  }

  Widget _buildEmptyMessage() {
    return Column(
      children: [
        Text(
          'No results found',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Text(
          searchQuery.isNotEmpty
              ? 'We couldn\'t find any medicines matching "$searchQuery"'
              : 'Try searching for medicines, brands, or categories',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Suggestions',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        _buildSuggestionChips(),
      ],
    );
  }

  Widget _buildSuggestionChips() {
    final suggestions = [
      'Check spelling',
      'Try different keywords',
      'Use generic names',
      'Search by brand',
      'Browse categories',
    ];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: suggestions.map((suggestion) {
        return ActionChip(
          label: Text(
            suggestion,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          backgroundColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          side: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
          onPressed: onSearchSuggestionTap,
        );
      }).toList(),
    );
  }

  Widget _buildPopularMedicines() {
    final popularMedicines = [
      {
        'name': 'Paracetamol 500mg',
        'category': 'Pain Relief',
        'icon': 'medication',
      },
      {
        'name': 'Vitamin D3',
        'category': 'Supplements',
        'icon': 'vitamins',
      },
      {
        'name': 'Ibuprofen 400mg',
        'category': 'Anti-inflammatory',
        'icon': 'medication',
      },
      {
        'name': 'Omega-3 Fish Oil',
        'category': 'Supplements',
        'icon': 'vitamins',
      },
      {
        'name': 'Cetirizine 10mg',
        'category': 'Allergy Relief',
        'icon': 'medication',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Medicines',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: popularMedicines.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final medicine = popularMedicines[index];
            return _buildPopularMedicineItem(medicine);
          },
        ),
      ],
    );
  }

  Widget _buildPopularMedicineItem(Map<String, dynamic> medicine) {
    final String name = medicine['name'] as String;
    final String category = medicine['category'] as String;
    final String iconName = medicine['icon'] as String;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        leading: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ),
        title: Text(
          name,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          category,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.6),
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'arrow_forward_ios',
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.3),
          size: 16,
        ),
        onTap: () {
          // Navigate to product details or search for this medicine
        },
      ),
    );
  }
}
