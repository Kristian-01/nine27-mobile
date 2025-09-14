import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrescriptionVerificationWidget extends StatefulWidget {
  final List<Map<String, dynamic>> prescriptionItems;
  final Map<String, String> uploadedPrescriptions;
  final Function(String, String) onPrescriptionUploaded;

  const PrescriptionVerificationWidget({
    super.key,
    required this.prescriptionItems,
    required this.uploadedPrescriptions,
    required this.onPrescriptionUploaded,
  });

  @override
  State<PrescriptionVerificationWidget> createState() =>
      _PrescriptionVerificationWidgetState();
}

class _PrescriptionVerificationWidgetState
    extends State<PrescriptionVerificationWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    if (widget.prescriptionItems.isEmpty) {
      return const SizedBox.shrink();
    }

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
                    iconName: 'medical_services',
                    color: AppTheme.warningLight,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prescription Verification Required',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          '${widget.prescriptionItems.length} item(s) require prescription',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.warningLight,
                                  ),
                        ),
                      ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.warningLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.warningLight.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: AppTheme.warningLight,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'Please upload valid prescriptions for the following items. Orders will be processed after verification.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.warningLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ...widget.prescriptionItems.map((item) {
                    final itemId = item['id'].toString();
                    final hasUploadedPrescription =
                        widget.uploadedPrescriptions.containsKey(itemId);

                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: hasUploadedPrescription
                              ? AppTheme.successLight
                              : AppTheme.lightTheme.dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: hasUploadedPrescription
                            ? AppTheme.successLight.withValues(alpha: 0.05)
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CustomImageWidget(
                                  imageUrl: item['image'] as String? ?? '',
                                  width: 12.w,
                                  height: 12.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'] as String? ??
                                          'Unknown Product',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      'Qty: ${item['quantity']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (hasUploadedPrescription)
                                Container(
                                  padding: EdgeInsets.all(1.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.successLight,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'check',
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          hasUploadedPrescription
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme.successLight
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'check_circle',
                                        color: AppTheme.successLight,
                                        size: 16,
                                      ),
                                      SizedBox(width: 2.w),
                                      Expanded(
                                        child: Text(
                                          'Prescription uploaded successfully',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppTheme.successLight,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            _showPrescriptionUploadDialog(
                                                itemId, item['name'] as String),
                                        child: Text(
                                          'Change',
                                          style: TextStyle(
                                            color: AppTheme.successLight,
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () =>
                                        _showPrescriptionUploadDialog(
                                            itemId, item['name'] as String),
                                    icon: CustomIconWidget(
                                      iconName: 'upload_file',
                                      color: AppTheme.lightTheme.primaryColor,
                                      size: 18,
                                    ),
                                    label: Text('Upload Prescription'),
                                    style: OutlinedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.5.h),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showPrescriptionUploadDialog(String itemId, String itemName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upload Prescription'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload prescription for:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 1.h),
            Text(
              itemName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Choose upload method:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _simulateImageCapture(itemId);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'camera_alt',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text('Camera'),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _simulateFileUpload(itemId);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'photo_library',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text('Gallery'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _simulateImageCapture(String itemId) {
    // Simulate image capture process
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: AppTheme.lightTheme.primaryColor,
            ),
            SizedBox(height: 2.h),
            Text('Capturing prescription...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      widget.onPrescriptionUploaded(itemId,
          'prescription_camera_${DateTime.now().millisecondsSinceEpoch}.jpg');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Prescription uploaded successfully'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    });
  }

  void _simulateFileUpload(String itemId) {
    // Simulate file upload process
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: AppTheme.lightTheme.primaryColor,
            ),
            SizedBox(height: 2.h),
            Text('Uploading prescription...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      widget.onPrescriptionUploaded(itemId,
          'prescription_upload_${DateTime.now().millisecondsSinceEpoch}.pdf');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Prescription uploaded successfully'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    });
  }
}
