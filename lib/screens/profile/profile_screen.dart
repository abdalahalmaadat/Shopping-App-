import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/products_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/product_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final favorites = productsProvider.favoriteProducts;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 60),
                
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppTheme.primary, AppTheme.primaryDark],
                    ),
                  ),
                  child: const Icon(Icons.person,
                      size: 50, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text(
                  'محمد أحمد',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'mohammed@email.com',
                  style: TextStyle(
                      color: AppTheme.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 24),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(label: 'الطلبات', value: '12'),
                      Container(
                          width: 1, height: 40, color: AppTheme.surfaceLight),
                      _StatItem(label: 'المفضلة', value: '${favorites.length}'),
                      Container(
                          width: 1, height: 40, color: AppTheme.surfaceLight),
                      _StatItem(label: 'المراجعات', value: '5'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _SettingsItem(
                          icon: Icons.location_on_outlined,
                          label: 'عناوين التوصيل',
                          onTap: () {}),
                      _divider(),
                      _SettingsItem(
                          icon: Icons.payment_outlined,
                          label: 'طرق الدفع',
                          onTap: () {}),
                      _divider(),
                      _SettingsItem(
                          icon: Icons.notifications_outlined,
                          label: 'الإشعارات',
                          onTap: () {}),
                      _divider(),
                      _SettingsItem(
                          icon: Icons.help_outline,
                          label: 'مركز المساعدة',
                          onTap: () {}),
                      _divider(),
                      _SettingsItem(
                          icon: Icons.logout,
                          label: 'تسجيل الخروج',
                          onTap: () {},
                          isDestructive: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (favorites.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'المفضلة ❤️',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),

          if (favorites.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      ProductCard(product: favorites[index]),
                  childCount: favorites.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, color: AppTheme.surfaceLight, indent: 16);
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.primary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style:
                const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppTheme.error : AppTheme.textPrimary;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 22),
      title: Text(label,
          style: TextStyle(
              color: color, fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios,
          size: 14,
          color: isDestructive
              ? AppTheme.error.withOpacity(0.5)
              : AppTheme.textSecondary),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}
