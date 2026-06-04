import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../utils/app_theme.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppTheme.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios,
                    size: 16, color: AppTheme.textPrimary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 18,
                    color: product.isFavorite
                        ? AppTheme.error
                        : AppTheme.textPrimary,
                  ),
                ),
                onPressed: () =>
                    productsProvider.toggleFavorite(product.id),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${product.id}',
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppTheme.surfaceLight,
                    child: const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primary),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.background,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                          color: AppTheme.primary, fontSize: 12),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    product.title,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '(${product.reviewCount} تقييم)',
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 13),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product.rating.toString(),
                        style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      RatingBarIndicator(
                        rating: product.rating,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: AppTheme.accent,
                        ),
                        itemCount: 5,
                        itemSize: 16,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Divider(color: AppTheme.surfaceLight),

                  const SizedBox(height: 16),

                  const Text(
                    'وصف المنتج',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.hasDiscount)
                            Text(
                              '\$${product.originalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (product.hasDiscount)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.error.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'وفّر ${product.discountPercent.toInt()}%',
                            style: const TextStyle(
                                color: AppTheme.error,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        cart.addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم إضافة ${product.title} للسلة',
                              textAlign: TextAlign.right,
                            ),
                            backgroundColor: AppTheme.success,
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: Text(
                        cart.isInCart(product.id)
                            ? 'تم الإضافة ✓'
                            : 'إضافة للسلة',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cart.isInCart(product.id)
                            ? AppTheme.success
                            : AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
