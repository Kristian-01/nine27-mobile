import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeliveryInfoWidget extends StatefulWidget {
  final Map<String, String> deliveryData;
  final Function(Map<String, String>) onDataChanged;

  const DeliveryInfoWidget({
    super.key,
    required this.deliveryData,
    required this.onDataChanged,
  });

  @override
  State<DeliveryInfoWidget> createState() => _DeliveryInfoWidgetState();
}

class _DeliveryInfoWidgetState extends State<DeliveryInfoWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _zipController;
  DateTime? _selectedDeliveryDate;
  TimeOfDay? _selectedDeliveryTime;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.deliveryData['name'] ?? '');
    _phoneController =
        TextEditingController(text: widget.deliveryData['phone'] ?? '');
    _addressController =
        TextEditingController(text: widget.deliveryData['address'] ?? '');
    _cityController =
        TextEditingController(text: widget.deliveryData['city'] ?? '');
    _zipController =
        TextEditingController(text: widget.deliveryData['zip'] ?? '');

    if (widget.deliveryData['deliveryDate'] != null) {
      _selectedDeliveryDate =
          DateTime.tryParse(widget.deliveryData['deliveryDate']!);
    }
    if (widget.deliveryData['deliveryTime'] != null) {
      final timeParts = widget.deliveryData['deliveryTime']!.split(':');
      if (timeParts.length == 2) {
        _selectedDeliveryTime = TimeOfDay(
          hour: int.tryParse(timeParts[0]) ?? 0,
          minute: int.tryParse(timeParts[1]) ?? 0,
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _updateData() {
    final data = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'city': _cityController.text,
      'zip': _zipController.text,
      'deliveryDate': _selectedDeliveryDate?.toIso8601String() ?? '',
      'deliveryTime': _selectedDeliveryTime != null
          ? '${_selectedDeliveryTime!.hour.toString().padLeft(2, '0')}:${_selectedDeliveryTime!.minute.toString().padLeft(2, '0')}'
          : '',
    };
    widget.onDataChanged(data);
  }

  Future<void> _selectDeliveryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDeliveryDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.primaryColor,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDeliveryDate) {
      setState(() {
        _selectedDeliveryDate = picked;
      });
      _updateData();
    }
  }

  Future<void> _selectDeliveryTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedDeliveryTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.primaryColor,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDeliveryTime) {
      setState(() {
        _selectedDeliveryTime = picked;
      });
      _updateData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'local_shipping',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Delivery Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(height: 1, color: AppTheme.lightTheme.dividerColor),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name *',
                        hintText: 'Enter your full name',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                      onChanged: (_) => _updateData(),
                    ),
                    SizedBox(height: 2.h),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number *',
                        hintText: 'Enter your phone number',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      onChanged: (_) => _updateData(),
                    ),
                    SizedBox(height: 2.h),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Complete Address *',
                        hintText: 'Street address, apartment, suite, etc.',
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your complete address';
                        }
                        return null;
                      },
                      onChanged: (_) => _updateData(),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: 'City *',
                              hintText: 'Enter city',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter city';
                              }
                              return null;
                            },
                            onChanged: (_) => _updateData(),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: TextFormField(
                            controller: _zipController,
                            decoration: const InputDecoration(
                              labelText: 'ZIP Code *',
                              hintText: 'ZIP',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter ZIP code';
                              }
                              return null;
                            },
                            onChanged: (_) => _updateData(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Delivery Preferences',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _selectDeliveryDate,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppTheme.lightTheme.dividerColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'calendar_today',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    size: 20,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      _selectedDeliveryDate != null
                                          ? '${_selectedDeliveryDate!.day}/${_selectedDeliveryDate!.month}/${_selectedDeliveryDate!.year}'
                                          : 'Select Date',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: InkWell(
                            onTap: _selectDeliveryTime,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppTheme.lightTheme.dividerColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'access_time',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    size: 20,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      _selectedDeliveryTime != null
                                          ? _selectedDeliveryTime!
                                              .format(context)
                                          : 'Select Time',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }
}
