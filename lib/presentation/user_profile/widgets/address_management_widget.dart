import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddressManagementWidget extends StatelessWidget {
  final List<Map<String, dynamic>> addresses;
  final VoidCallback onAddAddress;
  final Function(Map<String, dynamic>) onEditAddress;
  final Function(int) onDeleteAddress;
  final Function(int) onSetDefault;

  const AddressManagementWidget({
    super.key,
    required this.addresses,
    required this.onAddAddress,
    required this.onEditAddress,
    required this.onDeleteAddress,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(colorScheme),
        SizedBox(height: 3.h),
        ...addresses.map((address) => _buildAddressCard(address, colorScheme)),
        SizedBox(height: 2.h),
        _buildAddAddressButton(colorScheme),
      ],
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Text(
      'Delivery Addresses',
      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildAddressCard(
      Map<String, dynamic> address, ColorScheme colorScheme) {
    final isDefault = address['isDefault'] ?? false;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border:
            isDefault ? Border.all(color: colorScheme.primary, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    address['label'] ?? 'Address',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (isDefault) ...[
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Default',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(value, address),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        CustomIconWidget(iconName: 'edit', size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  if (!isDefault)
                    const PopupMenuItem(
                      value: 'setDefault',
                      child: Row(
                        children: [
                          CustomIconWidget(iconName: 'star', size: 18),
                          SizedBox(width: 8),
                          Text('Set as Default'),
                        ],
                      ),
                    ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'delete',
                          size: 18,
                          color: AppTheme.errorLight,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Delete',
                          style: TextStyle(color: AppTheme.errorLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                size: 20,
                color: AppTheme.textSecondaryLight,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address['address'] ?? '',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${address['city']}, ${address['state']} ${address['zipCode']}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddAddressButton(ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onAddAddress,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.primary),
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'add',
              size: 20,
              color: colorScheme.primary,
            ),
            SizedBox(width: 2.w),
            Text(
              'Add New Address',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action, Map<String, dynamic> address) {
    switch (action) {
      case 'edit':
        onEditAddress(address);
        break;
      case 'setDefault':
        onSetDefault(address['id']);
        break;
      case 'delete':
        onDeleteAddress(address['id']);
        break;
    }
  }
}
