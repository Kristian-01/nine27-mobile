import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>> onFiltersChanged;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _priceRange = RangeValues(
      (_filters['minPrice'] as double?) ?? 0.0,
      (_filters['maxPrice'] as double?) ?? 500.0,
    );
  }

  void _applyFilters() {
    _filters['minPrice'] = _priceRange.start;
    _filters['maxPrice'] = _priceRange.end;
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _filters = {
        'availability': 'all',
        'prescriptionRequired': false,
        'minPrice': 0.0,
        'maxPrice': 500.0,
        'sortBy': 'name',
      };
      _priceRange = const RangeValues(0.0, 500.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Filter Products',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceRangeSection(context),
                  SizedBox(height: 3.h),
                  _buildAvailabilitySection(context),
                  SizedBox(height: 3.h),
                  _buildPrescriptionSection(context),
                  SizedBox(height: 3.h),
                  _buildSortBySection(context),
                ],
              ),
            ),
          ),
          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Text(
                  'Apply Filters',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Text(
              '\$${_priceRange.start.round()}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Text(
              '\$${_priceRange.end.round()}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
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
      ],
    );
  }

  Widget _buildAvailabilitySection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Availability',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Column(
          children: [
            _buildRadioOption(
              context,
              'All Products',
              'all',
              _filters['availability'] as String,
              (value) => setState(() => _filters['availability'] = value),
            ),
            _buildRadioOption(
              context,
              'In Stock Only',
              'in_stock',
              _filters['availability'] as String,
              (value) => setState(() => _filters['availability'] = value),
            ),
            _buildRadioOption(
              context,
              'Out of Stock',
              'out_of_stock',
              _filters['availability'] as String,
              (value) => setState(() => _filters['availability'] = value),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrescriptionSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prescription Required',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: Text(
                'Show only prescription medicines',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Switch(
              value: _filters['prescriptionRequired'] as bool,
              onChanged: (value) {
                setState(() {
                  _filters['prescriptionRequired'] = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSortBySection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Column(
          children: [
            _buildRadioOption(
              context,
              'Name (A-Z)',
              'name',
              _filters['sortBy'] as String,
              (value) => setState(() => _filters['sortBy'] = value),
            ),
            _buildRadioOption(
              context,
              'Price (Low to High)',
              'price_low',
              _filters['sortBy'] as String,
              (value) => setState(() => _filters['sortBy'] = value),
            ),
            _buildRadioOption(
              context,
              'Price (High to Low)',
              'price_high',
              _filters['sortBy'] as String,
              (value) => setState(() => _filters['sortBy'] = value),
            ),
            _buildRadioOption(
              context,
              'Most Popular',
              'popular',
              _filters['sortBy'] as String,
              (value) => setState(() => _filters['sortBy'] = value),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(
    BuildContext context,
    String title,
    String value,
    String groupValue,
    ValueChanged<String> onChanged,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
