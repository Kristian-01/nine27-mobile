import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/category_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/search_bar_widget.dart';

class ProductCategories extends StatefulWidget {
  const ProductCategories({super.key});

  @override
  State<ProductCategories> createState() => _ProductCategoriesState();
}

class _ProductCategoriesState extends State<ProductCategories>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late ScrollController _scrollController;

  List<int> _expandedCategories = [];
  Map<String, dynamic> _currentFilters = {
    'availability': 'all',
    'prescriptionRequired': false,
    'minPrice': 0.0,
    'maxPrice': 500.0,
    'sortBy': 'name',
  };

  // Mock data for pharmaceutical categories
  final List<Map<String, dynamic>> _categories = [
    {
      "id": 1,
      "name": "Over-the-Counter",
      "icon": "local_pharmacy",
      "color": AppTheme.lightTheme.colorScheme.primary,
      "productCount": 245,
      "subcategories": [
        {"name": "Pain Relief", "count": 45},
        {"name": "Cold & Flu", "count": 38},
        {"name": "Digestive Health", "count": 32},
        {"name": "Allergy Relief", "count": 28},
        {"name": "Sleep Aids", "count": 22},
        {"name": "Cough & Throat", "count": 35},
        {"name": "Skin Care", "count": 45},
      ],
    },
    {
      "id": 2,
      "name": "Prescription",
      "icon": "receipt_long",
      "color": AppTheme.lightTheme.colorScheme.error,
      "productCount": 189,
      "subcategories": [
        {"name": "Antibiotics", "count": 42},
        {"name": "Blood Pressure", "count": 35},
        {"name": "Diabetes", "count": 28},
        {"name": "Heart Medications", "count": 25},
        {"name": "Mental Health", "count": 31},
        {"name": "Hormones", "count": 28},
      ],
    },
    {
      "id": 3,
      "name": "Vitamins & Supplements",
      "icon": "eco",
      "color": AppTheme.lightTheme.colorScheme.tertiary,
      "productCount": 312,
      "subcategories": [
        {"name": "Multivitamins", "count": 58},
        {"name": "Vitamin D", "count": 45},
        {"name": "Omega-3", "count": 38},
        {"name": "Probiotics", "count": 42},
        {"name": "Protein Supplements", "count": 35},
        {"name": "Herbal Supplements", "count": 48},
        {"name": "Minerals", "count": 46},
      ],
    },
    {
      "id": 4,
      "name": "First Aid",
      "icon": "medical_services",
      "color": AppTheme.lightTheme.colorScheme.error,
      "productCount": 87,
      "subcategories": [
        {"name": "Bandages & Gauze", "count": 25},
        {"name": "Antiseptics", "count": 18},
        {"name": "Wound Care", "count": 22},
        {"name": "Emergency Supplies", "count": 12},
        {"name": "Thermometers", "count": 10},
      ],
    },
    {
      "id": 5,
      "name": "Personal Care",
      "icon": "self_care",
      "color": AppTheme.lightTheme.colorScheme.secondary,
      "productCount": 156,
      "subcategories": [
        {"name": "Oral Care", "count": 42},
        {"name": "Hair Care", "count": 38},
        {"name": "Body Care", "count": 35},
        {"name": "Feminine Care", "count": 25},
        {"name": "Baby Care", "count": 16},
      ],
    },
    {
      "id": 6,
      "name": "Medical Devices",
      "icon": "monitor_heart",
      "color": AppTheme.lightTheme.colorScheme.primary,
      "productCount": 94,
      "subcategories": [
        {"name": "Blood Pressure Monitors", "count": 15},
        {"name": "Glucose Meters", "count": 12},
        {"name": "Nebulizers", "count": 8},
        {"name": "Mobility Aids", "count": 25},
        {"name": "Diagnostic Tools", "count": 18},
        {"name": "Home Testing", "count": 16},
      ],
    },
  ];

  // Search suggestions for medicine-specific autocomplete
  final List<String> _searchSuggestions = [
    "Acetaminophen",
    "Ibuprofen",
    "Aspirin",
    "Amoxicillin",
    "Lisinopril",
    "Metformin",
    "Atorvastatin",
    "Omeprazole",
    "Vitamin D3",
    "Multivitamin",
    "Omega-3",
    "Probiotics",
    "Bandages",
    "Antiseptic",
    "Thermometer",
    "Blood pressure monitor",
    "Glucose meter",
    "Toothpaste",
    "Shampoo",
    "Lotion",
    "Cold medicine",
    "Allergy relief",
    "Pain relief",
    "Sleep aid",
    "Cough syrup",
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleCategoryExpansion(int categoryId) {
    setState(() {
      if (_expandedCategories.contains(categoryId)) {
        _expandedCategories.remove(categoryId);
      } else {
        _expandedCategories.add(categoryId);
      }
    });
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      // Navigate to search results with query
      Navigator.pushNamed(context, '/search-results', arguments: {
        'query': query,
        'filters': _currentFilters,
      });
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _currentFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _currentFilters = filters;
          });
        },
      ),
    );
  }

  void _onViewAllCategory(Map<String, dynamic> category) {
    Navigator.pushNamed(context, '/search-results', arguments: {
      'category': category["name"],
      'filters': _currentFilters,
    });
  }

  void _onAddToFavorites(Map<String, dynamic> category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${category["name"]} added to favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onSetNotifications(Map<String, dynamic> category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notifications enabled for ${category["name"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredCategories() {
    List<Map<String, dynamic>> filteredCategories = List.from(_categories);

    // Apply search filter if search query exists
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filteredCategories = filteredCategories.where((category) {
        final categoryName = (category["name"] as String).toLowerCase();
        final subcategories =
            category["subcategories"] as List<Map<String, dynamic>>?;

        // Check if category name matches
        if (categoryName.contains(searchQuery)) {
          return true;
        }

        // Check if any subcategory matches
        if (subcategories != null) {
          return subcategories.any((sub) =>
              (sub["name"] as String).toLowerCase().contains(searchQuery));
        }

        return false;
      }).toList();
    }

    return filteredCategories;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filteredCategories = _getFilteredCategories();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const CustomAppBar(
        title: 'Product Categories',
        showBackButton: false,
        showSearchAction: false,
        showCartAction: true,
        cartItemCount: 3,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Sticky search bar
            Container(
              color: colorScheme.surface,
              child: SearchBarWidget(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onFilterTap: _showFilterBottomSheet,
                suggestions: _searchSuggestions,
              ),
            ),
            // Categories list
            Expanded(
              child: filteredCategories.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(bottom: 2.h),
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = filteredCategories[index];
                        final categoryId = category["id"] as int;
                        final isExpanded =
                            _expandedCategories.contains(categoryId);

                        return Slidable(
                          key: ValueKey(categoryId),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) => _onViewAllCategory(category),
                                backgroundColor: colorScheme.primary,
                                foregroundColor: Colors.white,
                                icon: Icons.visibility,
                                label: 'View All',
                              ),
                              SlidableAction(
                                onPressed: (_) => _onAddToFavorites(category),
                                backgroundColor: colorScheme.tertiary,
                                foregroundColor: Colors.white,
                                icon: Icons.favorite,
                                label: 'Favorite',
                              ),
                              SlidableAction(
                                onPressed: (_) => _onSetNotifications(category),
                                backgroundColor: colorScheme.secondary,
                                foregroundColor: Colors.white,
                                icon: Icons.notifications,
                                label: 'Notify',
                              ),
                            ],
                          ),
                          child: CategoryCardWidget(
                            category: category,
                            isExpanded: isExpanded,
                            onTap: () => _toggleCategoryExpansion(categoryId),
                            onViewAll: () => _onViewAllCategory(category),
                            onAddToFavorites: () => _onAddToFavorites(category),
                            onSetNotifications: () =>
                                _onSetNotifications(category),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 1,
        cartItemCount: 3,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No categories found',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Try searching for different terms or check your spelling',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Popular searches:',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: [
                    'Pain Relief',
                    'Vitamins',
                    'First Aid',
                    'Cold Medicine'
                  ]
                      .map((suggestion) => InkWell(
                            onTap: () {
                              _searchController.text = suggestion;
                              _onSearchChanged(suggestion);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: colorScheme.primary
                                      .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                suggestion,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
