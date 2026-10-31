import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const TitusApp());
}

class TitusApp extends StatelessWidget {
  const TitusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تيتوس | Titus - بيتزا ومعجنات وشاورما',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: const Color(0xFFFAF8F5),
        primaryColor: const Color(0xFFFFB800),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB800),
          primary: const Color(0xFFFFB800),
          surface: const Color(0xFFFAF8F5),
        ),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const MainRestaurantScreen(),
    );
  }
}

// Data Model
class Product {
  final String id;
  final String title;
  final String category;
  final double price;
  final String rating;
  final String image;
  final String? badge;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.image,
    this.badge,
  });
}

class CategoryItem {
  final String id;
  final String name;
  final String icon;

  CategoryItem({required this.id, required this.name, required this.icon});
}

class MainRestaurantScreen extends StatefulWidget {
  const MainRestaurantScreen({super.key});

  @override
  State<MainRestaurantScreen> createState() => _MainRestaurantScreenState();
}

class _MainRestaurantScreenState extends State<MainRestaurantScreen> {
  int _currentNavIndex = 0;
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final String whatsappNumber = "201064520957";

  Future<void> _openWhatsApp({String message = "مرحباً مطعم تيتوس، أريد الاستفسار عن المنيو والطلبات"}) async {
    final cleanPhone = whatsappNumber.replaceAll('+', '').replaceAll(' ', '');
    final uri = Uri.parse("https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}");
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح واتساب مباشرة، تأكد من تثبيت التطبيق.')),
        );
      }
    }
  }

  final List<CategoryItem> categories = [
    CategoryItem(id: 'all', name: 'الكل', icon: '🍽️'),
    CategoryItem(id: 'pizza', name: 'بيتزا', icon: '🍕'),
    CategoryItem(id: 'shawarma', name: 'شاورما', icon: '🌯'),
    CategoryItem(id: 'pastry', name: 'معجنات وفطائر', icon: '🥐'),
    CategoryItem(id: 'offers', name: 'العروض', icon: '🏷️'),
  ];

  final List<Product> products = [
    Product(
      id: 'p1',
      title: 'بيتزا بيبروني كلاسيك',
      category: 'pizza',
      price: 95,
      rating: '4.9',
      image: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=600&q=80',
      badge: 'الأكثر مبيعاً',
    ),
    Product(
      id: 'p2',
      title: 'ساندوتش شاورما عربي',
      category: 'shawarma',
      price: 65,
      rating: '4.8',
      image: 'https://images.unsplash.com/photo-1561651823-34feb02250e4?auto=format&fit=crop&w=600&q=80',
      badge: 'خلطة تيتوس',
    ),
    Product(
      id: 'p3',
      title: 'بيتزا سوبر سوبريم جبن',
      category: 'pizza',
      price: 110,
      rating: '4.9',
      image: 'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?auto=format&fit=crop&w=600&q=80',
    ),
    Product(
      id: 'p4',
      title: 'فطيرة كيري وعسل مورقة',
      category: 'pastry',
      price: 55,
      rating: '4.7',
      image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=600&q=80',
      badge: 'طازة من الفرن',
    ),
    Product(
      id: 'p5',
      title: 'شاورما لحمة بالصاج والجبن',
      category: 'shawarma',
      price: 75,
      rating: '4.9',
      image: 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?auto=format&fit=crop&w=600&q=80',
    ),
    Product(
      id: 'p6',
      title: 'معجنات مكس أجبان وزعتر',
      category: 'pastry',
      price: 45,
      rating: '4.6',
      image: 'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?auto=format&fit=crop&w=600&q=80',
    ),
    Product(
      id: 'p7',
      title: 'عرض الكومبو العائلي',
      category: 'offers',
      price: 185,
      rating: '5.0',
      image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80',
      badge: 'توفير 25%',
    ),
    Product(
      id: 'p8',
      title: 'بيتزا باربيكيو تشيكن',
      category: 'pizza',
      price: 105,
      rating: '4.8',
      image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=600&q=80',
      badge: 'جديد',
    ),
  ];

  // Cart state: Product ID -> Quantity
  final Map<String, int> cart = {};

  void _addToCart(String productId) {
    setState(() {
      cart[productId] = (cart[productId] ?? 0) + 1;
    });

    final item = products.firstWhere((p) => p.id == productId);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('🍕 ', style: TextStyle(fontSize: 18)),
            Expanded(child: Text('تمت إضافة "${item.title}" إلى السلة!')),
          ],
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF1F1E1B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _changeQty(String productId, int delta) {
    setState(() {
      if (!cart.containsKey(productId)) return;
      final newQty = cart[productId]! + delta;
      if (newQty <= 0) {
        cart.remove(productId);
      } else {
        cart[productId] = newQty;
      }
    });
  }

  double get _subtotalPrice {
    double sum = 0;
    cart.forEach((id, qty) {
      final p = products.firstWhere((item) => item.id == id);
      sum += p.price * qty;
    });
    return sum;
  }

  int get _totalItemsCount => cart.values.fold(0, (sum, count) => sum + count);

  List<Product> get _filteredProducts {
    return products.where((p) {
      final matchCategory = _selectedCategory == 'all' || p.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty || p.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      // Floating WhatsApp Button
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: _totalItemsCount > 0 ? 70 : 10),
        child: FloatingActionButton.extended(
          heroTag: 'whatsapp_btn',
          onPressed: () => _openWhatsApp(),
          backgroundColor: const Color(0xFF25D366),
          elevation: 5,
          icon: const Icon(Icons.chat, color: Colors.white, size: 24),
          label: const Text(
            'واتساب المطعم',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // 1. App Header with Logo & Motto
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14, left: 16, right: 16, bottom: 8),
                    child: Column(
                      children: [
                        // Brand Logo & Motto
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFE59800), Color(0xFFFFB800)],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFFB800).withOpacity(0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text('🔥', style: TextStyle(fontSize: 20)),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'تيتوس',
                                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Color(0xFF1F1E1B)),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFF8E1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        'TITUS',
                                        style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFE59800), fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  'بيتزا • معجنات • شاورما',
                                  style: TextStyle(color: Color(0xFF7E7A75), fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Search Input
                        Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black.withOpacity(0.08)),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3))
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              setState(() => _searchQuery = val.trim());
                            },
                            decoration: InputDecoration(
                              hintText: 'ابحث عن وجبتك المفضلة...',
                              hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
                              prefixIcon: const Icon(Icons.search, color: Colors.black45, size: 22),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18, color: Colors.black45),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Golden Promo Banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => _addToCart('p7'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFB800), Color(0xFFFFA000)],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFB800).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1F1E1B),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'عرض اليوم الخاص ⚡',
                                      style: TextStyle(color: Color(0xFFFFB800), fontSize: 10, fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'عرض شلة تيتوس:',
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1F1E1B)),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    '2 بيتزا لارج + 2 شاورما + بيبسي',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2B2927)),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: const [
                                      Text(
                                        '185 ج.م',
                                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1F1E1B)),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '250 ج.م',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          decoration: TextDecoration.lineThrough,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Food preview with badge
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=350&q=80',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 100,
                                      height: 100,
                                      color: const Color(0xFFFFB800),
                                      alignment: Alignment.center,
                                      child: const Text('🍕', style: TextStyle(fontSize: 40)),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 4,
                                  left: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                                    ),
                                    child: const Text(
                                      'وفر 25%',
                                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: Color(0xFF1F1E1B)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // 3. Category Tabs (Horizontal Pills)
                SliverToBoxAdapter(
                  child: Container(
                    height: 48,
                    margin: const EdgeInsets.only(top: 8, bottom: 4),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = cat.id == _selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              setState(() => _selectedCategory = cat.id);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFFFB800) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : Colors.black.withOpacity(0.08),
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFFFB800).withOpacity(0.35),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        )
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Text(cat.icon, style: const TextStyle(fontSize: 14)),
                                  const SizedBox(width: 6),
                                  Text(
                                    cat.name,
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                                      color: isSelected ? const Color(0xFF1F1E1B) : const Color(0xFF555555),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // 4. Section Title & Count
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedCategory == 'all'
                              ? 'الأكثر طلباً الآن'
                              : categories.firstWhere((c) => c.id == _selectedCategory).name,
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1F1E1B)),
                        ),
                        Text(
                          '${filtered.length} صنف',
                          style: const TextStyle(color: Color(0xFF7E7A75), fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

                // 5. Products Grid (Cards with Real Images, Ratings, Badges, Add Button)
                filtered.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              children: [
                                Text('🔍', style: TextStyle(fontSize: 40)),
                                SizedBox(height: 8),
                                Text('لا توجد أصناف مطابقة للبحث', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.73,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final p = filtered[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Food Image with Badge & Rating
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: Image.network(
                                              p.image,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Container(
                                                color: const Color(0xFFFFF8E1),
                                                alignment: Alignment.center,
                                                child: const Text('🍕', style: TextStyle(fontSize: 36)),
                                              ),
                                            ),
                                          ),
                                          if (p.badge != null)
                                            Positioned(
                                              top: 6,
                                              right: 6,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFFB800),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  p.badge!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 9,
                                                    color: Color(0xFF1F1E1B),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          Positioned(
                                            bottom: 6,
                                            left: 6,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.65),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(Icons.star, color: Color(0xFFFFB800), size: 10),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    p.rating,
                                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    // Product Title
                                    Text(
                                      p.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1F1E1B)),
                                    ),

                                    const SizedBox(height: 6),

                                    // Price & Golden Plus Button
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${p.price.toInt()}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 16,
                                                color: Color(0xFFB87200),
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            const Text(
                                              'ج.م',
                                              style: TextStyle(fontSize: 10, color: Color(0xFF7E7A75), fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          borderRadius: BorderRadius.circular(16),
                                          onTap: () => _addToCart(p.id),
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFB800),
                                              borderRadius: BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFFFFB800).withOpacity(0.4),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                )
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                            child: const Icon(Icons.add, color: Color(0xFF1F1E1B), size: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            childCount: filtered.length,
                          ),
                        ),
                      ),

                const SliverToBoxAdapter(child: SizedBox(height: 140)),
              ],
            ),

            // 6. Floating Sticky Cart Bar (appears when cart items > 0)
            if (_totalItemsCount > 0)
              Positioned(
                bottom: 12,
                left: 16,
                right: 16,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _openCartBottomSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1E1B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFFB800).withOpacity(0.35)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB800),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$_totalItemsCount',
                                style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1F1E1B), fontSize: 15),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('الطلب الحالي', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                Text(
                                  '${_subtotalPrice.toInt()} ج.م',
                                  style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFFFB800), fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Text('عرض السلة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_back, color: Colors.white, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),

      // 7. Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black.withOpacity(0.06))),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, -4))
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentNavIndex,
          onTap: (index) {
            setState(() => _currentNavIndex = index);
            if (index == 0) {
              setState(() => _selectedCategory = 'all');
            } else if (index == 1) {
              setState(() => _selectedCategory = 'offers');
            } else if (index == 2) {
              _openCartBottomSheet(context);
            } else if (index == 3) {
              _openWhatsApp(message: "مرحباً، أود التواصل مع خدمة عملاء مطعم تيتوس");
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFB87200),
          unselectedItemColor: const Color(0xFF7E7A75),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'الرئيسية'),
            const BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), label: 'العروض'),
            BottomNavigationBarItem(
              icon: Badge(
                label: Text('$_totalItemsCount'),
                isLabelVisible: _totalItemsCount > 0,
                backgroundColor: const Color(0xFFFFB800),
                textColor: const Color(0xFF1F1E1B),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              label: 'السلة',
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.support_agent_rounded), label: 'تواصل معنا'),
          ],
        ),
      ),
    );
  }

  // 8. Cart Bottom Sheet Modal
  void _openCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFAF8F5),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final cartItems = cart.entries.toList();
            final subtotal = _subtotalPrice;
            const deliveryFee = 15.0;
            final grandTotal = subtotal + (cartItems.isEmpty ? 0 : deliveryFee);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('سلة الطلبات', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$_totalItemsCount أصناف',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF8A5300)),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.black12),

                  if (cartItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Text('🧺', style: TextStyle(fontSize: 48)),
                            SizedBox(height: 8),
                            Text('سلتك فارغة حالياً', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text('اختر من منيو تيتوس الشهي وابدأ طلبك الآن', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: cartItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final p = products.firstWhere((item) => item.id == cartItems[i].key);
                          final qty = cartItems[i].value;

                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.black.withOpacity(0.06)),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    p.image,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 50,
                                      height: 50,
                                      color: const Color(0xFFFFF8E1),
                                      alignment: Alignment.center,
                                      child: const Text('🍕'),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      Text('${p.price.toInt()} ج.م', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFB87200), fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFAF8F5),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _changeQty(p.id, -1);
                                          setSheetState(() {});
                                          setState(() {});
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          child: Text('-', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                                        ),
                                      ),
                                      Text('$qty', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                                      InkWell(
                                        onTap: () {
                                          _changeQty(p.id, 1);
                                          setSheetState(() {});
                                          setState(() {});
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          child: Text('+', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFFE59800))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 14),
                    const Divider(color: Colors.black12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('قيمة الأصناف:', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('${subtotal.toInt()} ج.م', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('خدمة التوصيل السريع:', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('15 ج.م', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الإجمالي التقريبي:', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                        Text('${grandTotal.toInt()} ج.م', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFFB87200))),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB800),
                        foregroundColor: const Color(0xFF1F1E1B),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _openCheckoutModal(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('متابعة الطلب السريع', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 9. Quick Checkout Modal
  void _openCheckoutModal(BuildContext context) {
    final phoneController = TextEditingController();
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    String paymentMethod = 'cash';

    final totalToPay = _subtotalPrice + 15;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
                top: 16,
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: const Text('🚀', style: TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(height: 8),
                    const Text('تأكيد أسرع طلب في مصر!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                    const Text('بدون كلمات سر ولا إيميلات معقدة، برقمك فقط', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(height: 16),

                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'رقم الموبايل (لتتبع الدليفري)',
                        prefixText: '+20  ',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'الاسم الكريم',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'عنوان التوصيل أو المكان بالتفصيل',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        prefixIcon: const Icon(Icons.location_on),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: const Text('طريقة الدفع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => setModalState(() => paymentMethod = 'cash'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              decoration: BoxDecoration(
                                color: paymentMethod == 'cash' ? const Color(0xFFFFF8E1) : const Color(0xFFFAF8F5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: paymentMethod == 'cash' ? const Color(0xFFFFB800) : Colors.black12,
                                  width: paymentMethod == 'cash' ? 2 : 1,
                                ),
                              ),
                              child: const Text(
                                '💵 كاش عند الاستلام',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => setModalState(() => paymentMethod = 'vodafone'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              decoration: BoxDecoration(
                                color: paymentMethod == 'vodafone' ? const Color(0xFFFFF8E1) : const Color(0xFFFAF8F5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: paymentMethod == 'vodafone' ? const Color(0xFFFFB800) : Colors.black12,
                                  width: paymentMethod == 'vodafone' ? 2 : 1,
                                ),
                              ),
                              child: const Text(
                                '📱 فودافون كاش / إنستاباي',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('المبلغ الإجمالي للدفع:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('${totalToPay.toInt()} ج.م', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF8A5300))),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('رجوع', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFB800),
                              foregroundColor: const Color(0xFF1F1E1B),
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 2,
                            ),
                            onPressed: () {
                              if (phoneController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  const SnackBar(content: Text('يرجى إدخال رقم الموبايل لتأكيد الطلب')),
                                );
                                return;
                              }

                              final phone = phoneController.text.trim();
                              final name = nameController.text.trim().isEmpty ? 'عميلنا العزيز' : nameController.text.trim();
                              final address = addressController.text.trim();
                              final orderId = '#TIT-${Random().nextInt(9000) + 1000}';

                              // إنشاء ملخص الطلب لإرساله لواتساب اختارياً
                              String orderSummary = "طلب جديد من تطبيق تيتوس ($orderId):\n"
                                  "العميل: $name\n"
                                  "الهاتف: $phone\n"
                                  "العنوان: $address\n"
                                  "طريقة الدفع: ${paymentMethod == 'cash' ? 'كاش' : 'فودافون كاش'}\n"
                                  "الإجمالي: ${totalToPay.toInt()} ج.م";

                              Navigator.pop(ctx);
                              setState(() => cart.clear());

                              _showSuccessOrderDialog(context, name, phone, orderId, orderSummary);
                            },
                            child: const Text('إرسال الطلب للمطبخ 👨‍🍳', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 10. Success Order Dialog
  void _showSuccessOrderDialog(BuildContext context, String name, String phone, String orderId, String orderSummary) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: Color(0xFFFFB800), width: 2),
        ),
        title: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: const Text('🍕', style: TextStyle(fontSize: 32)),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('طلبك وصل شيف تيتوس!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(
              'أهلاً بك يا $name! تم استلام طلبك وبدء التجهيز، وسيصلك اتصال لتأكيد العنوان على الرقم $phone.',
              style: const TextStyle(fontSize: 12, color: Color(0xFF7E7A75)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF8F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('رقم الطلب:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(orderId, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFE59800), fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('حالة الطلب:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      Text('جاري التجهيز في الفرن 🔥', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // WhatsApp Order Confirmation Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.chat, size: 18),
              label: const Text('إرسال تفاصيل الطلب عبر واتساب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              onPressed: () {
                _openWhatsApp(message: orderSummary);
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB800),
              foregroundColor: const Color(0xFF1F1E1B),
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('تم، شكراً لكم', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}
