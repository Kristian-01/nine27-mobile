import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final String? blurHash;
  final BorderRadius? borderRadius;
  final Duration fadeInDuration;
  final int memCacheHeight;
  final int memCacheWidth;

  /// Optional widget to show when the image fails to load.
  /// If null, a default asset image is shown.
  final Widget? errorWidget;

  const CustomImageWidget({
    Key? key,
    required this.imageUrl,
    this.width = 60,
    this.height = 60,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.blurHash,
    this.borderRadius,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.memCacheHeight = 0,
    this.memCacheWidth = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fallbackUrl = 'https://images.unsplash.com/photo-1584824486509-112e4181ff6b?q=80&w=500&auto=format&fit=crop';
    final imageProvider = CachedNetworkImageProvider(
      imageUrl ?? fallbackUrl,
      maxHeight: memCacheHeight > 0 ? memCacheHeight : null,
      maxWidth: memCacheWidth > 0 ? memCacheWidth : null,
    );

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl ?? fallbackUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration,
      memCacheHeight: memCacheHeight > 0 ? memCacheHeight : null,
      memCacheWidth: memCacheWidth > 0 ? memCacheWidth : null,
      
      // Use caller-supplied widget if provided, else fallback asset.
      errorWidget: (context, url, error) =>
          errorWidget ??
          Image.asset(
            "assets/images/no-image.jpg",
            fit: fit,
            width: width,
            height: height,
          ),

      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );

    // Apply border radius if specified
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
