import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CheckoutProgressWidget extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const CheckoutProgressWidget({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;
          final isLast = index == steps.length - 1;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted || isCurrent
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.2),
                          border: Border.all(
                            color: isCompleted || isCurrent
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: isCompleted
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 16,
                              )
                            : Center(
                                child: Text(
                                  '${index + 1}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: isCurrent
                                            ? Colors.white
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        steps[index],
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isCompleted || isCurrent
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                              fontWeight: isCompleted || isCurrent
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 8.w,
                    height: 2,
                    margin: EdgeInsets.only(bottom: 4.h),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
