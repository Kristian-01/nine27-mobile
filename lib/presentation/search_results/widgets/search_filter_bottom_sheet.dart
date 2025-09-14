import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const SearchFilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersApplied,
  });

  @override
  State<SearchFilterBottomSheet> createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  late Map<String, dynamic> _filters;
  RangeValues _priceRange = const RangeValues(0, 500);
  bool _prescriptionRequired = false;
  bool _otcOnly = false;
  bool _inStockOnly = true;
  String _selectedManufacturer = 'All';

  final List<String> _manufacturers = [
    'All',
    'Pfizer',
    'Johnson & Johnson',
    'Novartis',
    'Roche',
    'Merck',
    'GSK',
    'Sanofi',
    'AbbVie',
    'Bristol Myers Squibb'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _initializeFilters();
  }

  void _initializeFilters() {
    _priceRange = RangeValues(
      (_filters['minPrice'] as double?) ?? 0,
      (_filters['maxPrice'] as double?) ?? 500,
    );
    _prescriptionRequired = _filters['prescriptionRequired'] as bool? ?? false;
    _otcOnly = _filters['otcOnly'] as bool? ?? false;
    _inStockOnly = _filters['inStockOnly'] as bool? ?? true;
    _selectedManufacturer = _filters['manufacturer'] as String? ?? 'All';
  }

  void _applyFilters() {
    final updatedFilters = {
      'minPrice': _priceRange.start,
      'maxPrice': _priceRange.end,
      'prescriptionRequired': _prescriptionRequired,
      'otcOnly': _otcOnly,
      'inStockOnly': _inStockOnly,
      'manufacturer': _selectedManufacturer,
    };
    widget.onFiltersApplied(updatedFilters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 500);
      _prescriptionRequired = false;
      _otcOnly = false;
      _inStockOnly = true;
      _selectedManufacturer = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceRangeSection(),
                  SizedBox(height: 3.h),
                  _buildPrescriptionSection(),
                  SizedBox(height: 3.h),
                  _buildManufacturerSection(),
                  SizedBox(height: 3.h),
                  _buildAvailabilitySection(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Filter Results',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _clearFilters,
            child: Text(
              'Clear All',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 500,
          divisions: 50,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_priceRange.start.round()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '\$${_priceRange.end.round()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prescription Requirements',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        CheckboxListTile(
          title: Text(
            'Prescription Required',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          value: _prescriptionRequired,
          onChanged: (bool? value) {
            setState(() {
              _prescriptionRequired = value ?? false;
              if (_prescriptionRequired) _otcOnly = false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: Text(
            'Over-the-Counter Only',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          value: _otcOnly,
          onChanged: (bool? value) {
            setState(() {
              _otcOnly = value ?? false;
              if (_otcOnly) _prescriptionRequired = false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildManufacturerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manufacturer',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
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
              value: _selectedManufacturer,
              isExpanded: true,
              items: _manufacturers.map((String manufacturer) {
                return DropdownMenuItem<String>(
                  value: manufacturer,
                  child: Text(
                    manufacturer,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedManufacturer = newValue ?? 'All';
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Availability',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        CheckboxListTile(
          title: Text(
            'In Stock Only',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          value: _inStockOnly,
          onChanged: (bool? value) {
            setState(() {
              _inStockOnly = value ?? true;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: Text('Cancel'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
