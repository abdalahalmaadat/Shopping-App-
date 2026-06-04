import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../screens/products/product_detail_screen.dart';
import '../utils/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
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
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppTheme.surfaceLight,
                        highlightColor: AppTheme.surface,
                        child: Container(color: AppTheme.surfaceLight),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.surfaceLight,
                        child: const Icon(Icons.image_not_supported,
                            color: AppTheme.textSecondary),
                      ),
                    ),
                  ),
                  
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: () =>
                          productsProvider.toggleFavorite(product.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.background.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: product.isFavorite
                              ? AppTheme.error
                              : AppTheme.textSecondary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Column(
                      children: [
                        if (product.isNew)
                          _Badge(label: 'جديد', color: AppTheme.success),
                        if (product.hasDiscount) ...[
                          const SizedBox(height: 4),
                          _Badge(
                            label: '-${product.discountPercent.toInt()}%',
                            color: AppTheme.error,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: AppTheme.accent, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.toString(),
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            if (product.hasDiscount)
                              Text(
                                '\$${product.originalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => cart.addItem(product),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: cart.isInCart(product.id)
                                  ? AppTheme.primary
                                  : AppTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              cart.isInCart(product.id)
                                  ? Icons.shopping_cart
                                  : Icons.add_shopping_cart,
                              color: AppTheme.textPrimary,
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
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
