import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductSectionWidget extends StatelessWidget {
  final String title;
  final String sectionType;
  final VoidCallback? onViewAll;

  const ProductSectionWidget({
    super.key,
    required this.title,
    required this.sectionType,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final products = _getProductsByType(sectionType);

    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: onViewAll ??
                      () => Navigator.pushNamed(context, '/product-categories'),
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
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 35.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(context, product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return Container(
      width: 45.w,
      margin: EdgeInsets.only(right: 3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CustomImageWidget(
                    imageUrl: product["image"] as String,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (product["discount"] != null)
                  Positioned(
                    top: 2.w,
                    left: 2.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${product["discount"]}% OFF',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (product["prescriptionRequired"] == true)
                  Positioned(
                    top: 2.w,
                    right: 2.w,
                    child: Container(
                      padding: EdgeInsets.all(1.5.w),
                      decoration: BoxDecoration(
                        color: AppTheme.warningLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'receipt_long',
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product["name"] as String,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  if (product["manufacturer"] != null)
                    Text(
                      product["manufacturer"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product["price"] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (product["originalPrice"] != null)
                            Text(
                              product["originalPrice"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Add to cart functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product["name"]} added to cart'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'add_shopping_cart',
                            color: Colors.white,
                            size: 16,
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
      ),
    );
  }

  List<Map<String, dynamic>> _getProductsByType(String type) {
    switch (type) {
      case 'popular':
        return [
          {
            "id": 1,
            "name": "Paracetamol 500mg",
            "manufacturer": "HealthCorp",
            "price": "₱12.99",
            "originalPrice": "₱15.99",
            "discount": 20,
            "image":
                "https://images.pexels.com/photos/3683056/pexels-photo-3683056.jpeg?auto=compress&cs=tinysrgb&w=400",
            "prescriptionRequired": false,
            "inStock": true,
          },
          {
            "id": 2,
            "name": "Vitamin D3 1000 IU",
            "manufacturer": "NutriLife",
            "price": "₱24.99",
            "image":
                "https://images.pexels.com/photos/3786126/pexels-photo-3786126.jpeg?auto=compress&cs=tinysrgb&w=400",
            "prescriptionRequired": false,
            "inStock": true,
          },
          {
            "id": 3,
            "name": "Ibuprofen 400mg",
            "manufacturer": "MediCore",
            "price": "₱18.50",
            "originalPrice": "₱22.00",
            "discount": 15,
            "image":
                "https://images.pexels.com/photos/4386466/pexels-photo-4386466.jpeg?auto=compress&cs=tinysrgb&w=400",
            "prescriptionRequired": true,
            "inStock": true,
          },
        ];
      case 'supplements':
        return [
          {
            "id": 4,
            "name": "Omega-3 Fish Oil",
            "manufacturer": "HealthPlus",
            "price": "₱32.99",
            "image":
                "https://images.pexels.com/photos/3683056/pexels-photo-3683056.jpeg?auto=compress&cs=tinysrgb&w=400",
            "prescriptionRequired": false,
            "inStock": true,
          },
          {
            "id": 5,
            "name": "Multivitamin Complex",
            "manufacturer": "VitaMax",
            "price": "₱28.75",
            "originalPrice": "₱35.00",
            "discount": 18,
            "image":
                "https://images.pexels.com/photos/3786126/pexels-photo-3786126.jpeg?auto=compress&cs=tinysrgb&w=400",
            "prescriptionRequired": false,
            "inStock": true,
          },
          {
            "id": 6,
            "name": "Calcium + Magnesium",
            "manufacturer": "BoneHealth",
            "price": "₱21.99",
            "image":
                "https://images.pexels.com/photos/4386466/pexels-photo-4386466.jpeg?auto=compress&cs=tinysrgb&w=400",
            "prescriptionRequired": false,
            "inStock": true,
          },
        ];
      case 'offers':
        return [
          {
            "id": 7,
            "name": "Cough Syrup 100ml",
            "manufacturer": "CoughCare",
            "price": "₱8.99",
            "originalPrice": "₱14.99",
            "discount": 40,
            "image":
                "https://images.pexels.com/photos/3683056/pexels-photo-3683056.jpeg?auto=compress&cs=tinysrgb&w=400",
            "prescriptionRequired": false,
            "inStock": true,
          },
          {
            "id": 8,
            "name": "Antiseptic Cream",
            "manufacturer": "SkinCare",
            "price": "₱6.50",
            "originalPrice": "₱10.00",
            "discount": 35,
            "image":
                "https://images.pexels.com/photos/3786126/pexels-photo-3786126.jpeg?auto=compress&cs=tinysrgb&w=400",
            "prescriptionRequired": false,
            "inStock": true,
          },
          {
            "id": 9,
            "name": "Digital Thermometer",
            "manufacturer": "TechMed",
            "price": "₱15.99",
            "originalPrice": "₱25.99",
            "discount": 38,
            "image":
                "https://images.pexels.com/photos/4386466/pexels-photo-4386466.jpeg?auto=compress&cs=tinysrgb&w=400",
            "prescriptionRequired": false,
            "inStock": true,
          },
        ];
      default:
        return [];
    }
  }
}