import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../utils/favorites_storage.dart';

class ProductsProvider with ChangeNotifier {
  
  Future<void> loadSavedFavorites() async {
    final savedIds = await FavoritesStorage.loadFavorites();
    for (final product in _products) {
      product.isFavorite = savedIds.contains(product.id);
    }
    notifyListeners();
  }
  final List<Product> _products = [
    Product(
      id: '1',
      title: 'سماعات سوني WH-1000XM5',
      description:
          'سماعات لاسلكية فائقة الجودة مع إلغاء الضوضاء الرائد في الصناعة. استمتع بصوت نقي وواضح لساعات طويلة.',
      price: 89.99,
      originalPrice: 129.99,
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
      category: 'إلكترونيات',
      rating: 4.8,
      reviewCount: 2341,
      isNew: false,
    ),
    Product(
      id: '2',
      title: 'ساعة ذكية Apple Watch S9',
      description:
          'ساعة ذكية متطورة مع شاشة Always-On، تتبع الصحة، وبطارية تدوم يوماً كاملاً.',
      price: 299.99,
      originalPrice: 349.99,
      imageUrl:
          'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=500',
      category: 'إلكترونيات',
      rating: 4.9,
      reviewCount: 5120,
      isNew: true,
    ),
    Product(
      id: '3',
      title: 'حقيبة جلد فاخرة',
      description:
          'حقيبة يد نسائية من الجلد الأصلي الإيطالي، مثالية للعمل والمناسبات.',
      price: 149.00,
      originalPrice: 199.00,
      imageUrl:
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=500',
      category: 'أزياء',
      rating: 4.6,
      reviewCount: 876,
      isNew: false,
    ),
    Product(
      id: '4',
      title: 'حذاء نايك Air Max 270',
      description:
          'حذاء رياضي بتصميم عصري ووسادة هوائية ضخمة توفر راحة استثنائية طوال اليوم.',
      price: 120.00,
      originalPrice: 150.00,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
      category: 'أزياء',
      rating: 4.7,
      reviewCount: 3210,
      isNew: true,
    ),
    Product(
      id: '5',
      title: 'كاميرا سوني Alpha A7 IV',
      description:
          'كاميرا احترافية بدون مرآة بدقة 33 ميغابيكسل، مثالية للتصوير الاحترافي.',
      price: 2499.00,
      originalPrice: 2799.00,
      imageUrl:
          'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=500',
      category: 'إلكترونيات',
      rating: 4.9,
      reviewCount: 654,
      isNew: false,
    ),
    Product(
      id: '6',
      title: 'عطر شانيل No. 5',
      description:
          'العطر الأيقوني الخالد من دار شانيل، مزيج رائع من الأزهار والمسك.',
      price: 89.00,
      originalPrice: 110.00,
      imageUrl:
          'https://images.unsplash.com/photo-1541643600914-78b084683702?w=500',
      category: 'جمال',
      rating: 4.8,
      reviewCount: 1890,
      isNew: false,
    ),
    Product(
      id: '7',
      title: 'iPad Pro 12.9 بوصة',
      description:
          'اللوحي الأقوى من آبل بشريحة M2، شاشة Liquid Retina XDR، وأداء لا مثيل له.',
      price: 999.00,
      originalPrice: 1099.00,
      imageUrl:
          'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500',
      category: 'إلكترونيات',
      rating: 4.9,
      reviewCount: 4321,
      isNew: true,
    ),
    Product(
      id: '8',
      title: 'نظارات شمسية Ray-Ban Aviator',
      description:
          'النظارات الكلاسيكية الأيقونية من Ray-Ban بعدسات مستقطبة وإطار معدني أنيق.',
      price: 149.00,
      originalPrice: 180.00,
      imageUrl:
          'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500',
      category: 'أزياء',
      rating: 4.5,
      reviewCount: 2100,
      isNew: false,
    ),
  ];

  String _selectedCategory = 'الكل';
  String _searchQuery = '';

  List<String> get categories => [
        'الكل',
        'إلكترونيات',
        'أزياء',
        'جمال',
      ];

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<Product> get products {
    List<Product> filtered = _products;

    if (_selectedCategory != 'الكل') {
      filtered =
          filtered.where((p) => p.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.category.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  List<Product> get featuredProducts =>
      _products.where((p) => p.rating >= 4.8).toList();

  List<Product> get newProducts =>
      _products.where((p) => p.isNew).toList();

  List<Product> get favoriteProducts =>
      _products.where((p) => p.isFavorite).toList();

  Product findById(String id) => _products.firstWhere((p) => p.id == id);

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> toggleFavorite(String productId) async {
    final product = _products.firstWhere((p) => p.id == productId);
    product.isFavorite = !product.isFavorite;
    notifyListeners();
    
    await FavoritesStorage.saveFavorites(
      _products.where((p) => p.isFavorite).map((p) => p.id).toSet(),
    );
  }
}
