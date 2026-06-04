import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/cart_provider.dart';
import '../../utils/app_theme.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'سلة التسوق (${cart.totalQuantity})',
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.background,
        elevation: 0,
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: AppTheme.surface,
                    title: const Text('تفريغ السلة',
                        style: TextStyle(color: AppTheme.textPrimary),
                        textAlign: TextAlign.right),
                    content: const Text('هل تريد تفريغ السلة؟',
                        style: TextStyle(color: AppTheme.textSecondary),
                        textAlign: TextAlign.right),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء',
                            style: TextStyle(color: AppTheme.textSecondary)),
                      ),
                      TextButton(
                        onPressed: () {
                          cart.clearCart();
                          Navigator.pop(context);
                        },
                        child: const Text('تأكيد',
                            style: TextStyle(color: AppTheme.error)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('تفريغ',
                  style: TextStyle(color: AppTheme.error)),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: AppTheme.textSecondary.withOpacity(0.4)),
                  const SizedBox(height: 16),
                  const Text('السلة فارغة',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text('أضف منتجات لتبدأ التسوق',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 14)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items.values.toList()[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            
                            IconButton(
                              onPressed: () =>
                                  cart.removeItem(item.product.id),
                              icon: const Icon(Icons.delete_outline,
                                  color: AppTheme.error),
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    item.product.title,
                                    textAlign: TextAlign.right,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.surfaceLight,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.add,
                                                  size: 16,
                                                  color: AppTheme.textPrimary),
                                              onPressed: () => cart
                                                  .increaseQuantity(
                                                      item.product.id),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(
                                                      minWidth: 32,
                                                      minHeight: 32),
                                            ),
                                            Text(
                                              '${item.quantity}',
                                              style: const TextStyle(
                                                color: AppTheme.textPrimary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.remove,
                                                  size: 16,
                                                  color: AppTheme.textPrimary),
                                              onPressed: () => cart
                                                  .decreaseQuantity(
                                                      item.product.id),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(
                                                      minWidth: 32,
                                                      minHeight: 32),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      Text(
                                        '\$${item.totalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: item.product.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${cart.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('الإجمالي',
                                  style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 13)),
                              Text(
                                '${cart.totalQuantity} منتج',
                                style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CheckoutScreen(),
                              ),
                            );
                          },
                          child: const Text('إتمام الطلب'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
