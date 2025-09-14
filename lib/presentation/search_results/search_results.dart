import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_search_state.dart';
import './widgets/medicine_search_card.dart';
import './widgets/search_filter_bottom_sheet.dart';
import './widgets/search_suggestions_widget.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({super.key});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String _sortBy = 'relevance';
  bool _isLoading = false;
  bool _showSuggestions = false;
  Map<String, dynamic> _filters = {};
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _searchSuggestions = [];
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _searchFocusNode.addListener(_onSearchFocusChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    _loadRecentSearches();
    _loadMockData();
  }

  void _loadRecentSearches() {
    _recentSearches = [
      'Paracetamol',
      'Vitamin D3',
      'Ibuprofen',
      'Omega-3',
      'Cetirizine',
    ];
  }

  void _loadMockData() {
    _searchResults = [
      {
        'id': 1,
        'name': 'Paracetamol 500mg Tablets',
        'genericName': 'Acetaminophen',
        'manufacturer': 'Pfizer',
        'price': 12.99,
        'imageUrl':
            'https://images.pexels.com/photos/3683074/pexels-photo-3683074.jpeg',
        'inStock': true,
        'stockQuantity': 25,
        'prescriptionRequired': false,
        'category': 'Pain Relief',
      },
      {
        'id': 2,
        'name': 'Vitamin D3 1000 IU Capsules',
        'genericName': 'Cholecalciferol',
        'manufacturer': 'Johnson & Johnson',
        'price': 18.50,
        'imageUrl':
            'https://images.pexels.com/photos/3683056/pexels-photo-3683056.jpeg',
        'inStock': true,
        'stockQuantity': 15,
        'prescriptionRequired': false,
        'category': 'Supplements',
      },
      {
        'id': 3,
        'name': 'Ibuprofen 400mg Tablets',
        'genericName': 'Ibuprofen',
        'manufacturer': 'Novartis',
        'price': 15.75,
        'imageUrl':
            'https://images.pexels.com/photos/3683098/pexels-photo-3683098.jpeg',
        'inStock': true,
        'stockQuantity': 8,
        'prescriptionRequired': false,
        'category': 'Anti-inflammatory',
      },
      {
        'id': 4,
        'name': 'Omega-3 Fish Oil 1000mg',
        'genericName': 'EPA/DHA',
        'manufacturer': 'Roche',
        'price': 24.99,
        'imageUrl':
            'https://images.pexels.com/photos/3683089/pexels-photo-3683089.jpeg',
        'inStock': false,
        'stockQuantity': 0,
        'prescriptionRequired': false,
        'category': 'Supplements',
      },
      {
        'id': 5,
        'name': 'Cetirizine 10mg Tablets',
        'genericName': 'Cetirizine Hydrochloride',
        'manufacturer': 'GSK',
        'price': 9.99,
        'imageUrl':
            'https://images.pexels.com/photos/3683071/pexels-photo-3683071.jpeg',
        'inStock': true,
        'stockQuantity': 30,
        'prescriptionRequired': false,
        'category': 'Allergy Relief',
      },
      {
        'id': 6,
        'name': 'Metformin 500mg Extended Release',
        'genericName': 'Metformin Hydrochloride',
        'manufacturer': 'Merck',
        'price': 22.50,
        'imageUrl':
            'https://images.pexels.com/photos/3683081/pexels-photo-3683081.jpeg',
        'inStock': true,
        'stockQuantity': 12,
        'prescriptionRequired': true,
        'category': 'Diabetes',
      },
    ];
  }

  void _onSearchFocusChanged() {
    setState(() {
      _showSuggestions = _searchFocusNode.hasFocus && _searchQuery.length < 3;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreResults();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _showSuggestions = query.length < 3;
    });

    if (query.length >= 2) {
      _generateSearchSuggestions(query);
    } else {
      _searchSuggestions.clear();
    }

    if (query.length >= 3) {
      _performSearch(query);
    }
  }

  void _generateSearchSuggestions(String query) {
    final allSuggestions = [
      'Paracetamol 500mg',
      'Paracetamol tablets',
      'Panadol',
      'Vitamin D3 1000 IU',
      'Vitamin D supplements',
      'Vitamin B complex',
      'Ibuprofen 400mg',
      'Ibuprofen gel',
      'Advil',
      'Omega-3 fish oil',
      'Omega-3 capsules',
      'Fish oil supplements',
      'Cetirizine 10mg',
      'Cetirizine tablets',
      'Zyrtec',
      'Metformin 500mg',
      'Metformin extended release',
      'Diabetes medication',
    ];

    _searchSuggestions = allSuggestions
        .where((suggestion) =>
            suggestion.toLowerCase().contains(query.toLowerCase()))
        .take(8)
        .toList();
  }

  void _performSearch(String query) {
    setState(() {
      _isLoading = true;
      _showSuggestions = false;
    });

    // Add to recent searches
    if (!_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.take(10).toList();
      }
    }

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _loadMoreResults() {
    // Simulate loading more results
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _onSuggestionTap(String suggestion) {
    _searchController.text = suggestion;
    _onSearchChanged(suggestion);
    _searchFocusNode.unfocus();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchFilterBottomSheet(
        currentFilters: _filters,
        onFiltersApplied: (filters) {
          setState(() {
            _filters = filters;
          });
          _performSearch(_searchQuery);
        },
      ),
    );
  }

  void _onSortChanged(String? value) {
    if (value != null) {
      setState(() {
        _sortBy = value;
      });
      _performSearch(_searchQuery);
    }
  }

  List<Map<String, dynamic>> get _filteredResults {
    List<Map<String, dynamic>> results = List.from(_searchResults);

    // Apply filters
    if (_filters['inStockOnly'] == true) {
      results = results.where((item) => item['inStock'] == true).toList();
    }

    if (_filters['prescriptionRequired'] == true) {
      results = results
          .where((item) => item['prescriptionRequired'] == true)
          .toList();
    }

    if (_filters['otcOnly'] == true) {
      results = results
          .where((item) => item['prescriptionRequired'] == false)
          .toList();
    }

    if (_filters['manufacturer'] != null && _filters['manufacturer'] != 'All') {
      results = results
          .where((item) => item['manufacturer'] == _filters['manufacturer'])
          .toList();
    }

    final double minPrice = _filters['minPrice'] as double? ?? 0;
    final double maxPrice = _filters['maxPrice'] as double? ?? 500;
    results = results.where((item) {
      final double price = (item['price'] as num).toDouble();
      return price >= minPrice && price <= maxPrice;
    }).toList();

    // Apply sorting
    switch (_sortBy) {
      case 'price_low':
        results
            .sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
        break;
      case 'price_high':
        results
            .sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));
        break;
      case 'name':
        results.sort(
            (a, b) => (a['name'] as String).compareTo(b['name'] as String));
        break;
      case 'relevance':
      default:
        // Keep original order for relevance
        break;
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchHeader(),
          if (_showSuggestions) _buildSuggestionsSection(),
          if (!_showSuggestions) _buildResultsSection(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back_ios',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 20,
        ),
      ),
      title: Text(
        'Search Results',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/shopping-cart'),
          icon: CustomIconWidget(
            iconName: 'shopping_cart_outlined',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildSearchBar(),
          if (!_showSuggestions) ...[
            SizedBox(height: 2.h),
            _buildFilterAndSort(),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _searchFocusNode.hasFocus
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: _searchFocusNode.hasFocus ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search medicines, brands, categories...',
          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.5),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
              size: 20,
            ),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        ),
      ),
    );
  }

  Widget _buildFilterAndSort() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _showFilterBottomSheet,
            icon: CustomIconWidget(
              iconName: 'tune',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 18,
            ),
            label: Text('Filter'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _sortBy,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                      value: 'relevance', child: Text('Relevance')),
                  DropdownMenuItem(
                      value: 'price_low', child: Text('Price: Low to High')),
                  DropdownMenuItem(
                      value: 'price_high', child: Text('Price: High to Low')),
                  DropdownMenuItem(value: 'name', child: Text('Name A-Z')),
                ],
                onChanged: _onSortChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsSection() {
    return Expanded(
      child: SearchSuggestionsWidget(
        query: _searchQuery,
        suggestions:
            _searchQuery.isEmpty ? _recentSearches : _searchSuggestions,
        onSuggestionTap: _onSuggestionTap,
        onClearHistory: () {
          setState(() {
            _recentSearches.clear();
          });
        },
      ),
    );
  }

  Widget _buildResultsSection() {
    final filteredResults = _filteredResults;

    if (_isLoading && filteredResults.isEmpty) {
      return Expanded(child: _buildLoadingState());
    }

    if (filteredResults.isEmpty && !_isLoading) {
      return Expanded(
        child: EmptySearchState(
          searchQuery: _searchQuery,
          onSearchSuggestionTap: () {
            _searchFocusNode.requestFocus();
          },
        ),
      );
    }

    return Expanded(
      child: Column(
        children: [
          _buildResultsHeader(filteredResults.length),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: filteredResults.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == filteredResults.length) {
                  return _buildLoadingIndicator();
                }

                final medicine = filteredResults[index];
                return MedicineSearchCard(
                  medicine: medicine,
                  onTap: () {
                    // Navigate to product details
                    Navigator.pushNamed(context, '/product-details',
                        arguments: medicine);
                  },
                  onAddToCart: () {
                    _addToCart(medicine);
                  },
                  onAddToWishlist: () {
                    _addToWishlist(medicine);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader(int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Text(
            '$count results found',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          if (_searchQuery.isNotEmpty) ...[
            Text(
              ' for "$_searchQuery"',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Searching medicines...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> medicine) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine['name']} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => Navigator.pushNamed(context, '/shopping-cart'),
        ),
      ),
    );
  }

  void _addToWishlist(Map<String, dynamic> medicine) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine['name']} added to wishlist'),
      ),
    );
  }
}
