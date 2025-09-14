import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryGridWidget extends StatelessWidget {
  const CategoryGridWidget({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {
      "id": 1,
      "name": "Pain Relief",
      "icon": "healing",
      "color": Color(0xFFE3F2FD),
      "iconColor": Color(0xFF1976D2),
      "count": "120+ items",
    },
    {
      "id": 2,
      "name": "Vitamins",
      "icon": "local_pharmacy",
      "color": Color(0xFFF3E5F5),
      "iconColor": Color(0xFF7B1FA2),
      "count": "85+ items",
    },
    {
      "id": 3,
      "name": "First Aid",
      "icon": "medical_services",
      "color": Color(0xFFE8F5E8),
      "iconColor": Color(0xFF388E3C),
      "count": "65+ items",
    },
    {
      "id": 4,
      "name": "Prescription",
      "icon": "receipt_long",
      "color": Color(0xFFFFF3E0),
      "iconColor": Color(0xFFF57C00),
      "count": "200+ items",
    },
    {
      "id": 5,
      "name": "Baby Care",
      "icon": "child_care",
      "color": Color(0xFFFCE4EC),
      "iconColor": Color(0xFFC2185B),
      "count": "45+ items",
    },
    {
      "id": 6,
      "name": "Personal Care",
      "icon": "face",
      "color": Color(0xFFE0F2F1),
      "iconColor": Color(0xFF00695C),
      "count": "90+ items",
    },
    {
      "id": 7,
      "name": "Diabetes Care",
      "icon": "monitor_heart",
      "color": Color(0xFFEDE7F6),
      "iconColor": Color(0xFF512DA8),
      "count": "35+ items",
    },
    {
      "id": 8,
      "name": "Health Devices",
      "icon": "devices_other",
      "color": Color(0xFFF1F8E9),
      "iconColor": Color(0xFF689F38),
      "count": "25+ items",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shop by Category',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, '/product-categories'),
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.1,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return _buildCategoryCard(context, category);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product-categories'),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: category["color"] as Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: category["icon"] as String,
                color: category["iconColor"] as Color,
                size: 28,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              category["name"] as String,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            Text(
              category["count"] as String,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
