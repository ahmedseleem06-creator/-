import 'package:flutter/material.dart';

void main() {
  runApp(const TitusApp());
}

class TitusApp extends StatelessWidget {
  const TitusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تيتوس - Titus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: const Color(0xFFFAF8F5),
        primaryColor: const Color(0xFFFFB800),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB800),
          primary: const Color(0xFFFFB800),
        ),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const MainHomeScreen(),
    );
  }
}

class Product {
  final String id;
  final String title;
  final String category;
  final double price;
  final String icon;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.icon,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  String selectedCategory = 'الكل';
  final List<String> categories = ['الكل', 'بيتزا', 'شاورما', 'معجنات', 'عروض'];
  final Map<Product, int> cart = {};

  final List<Product> products = [
    Product(id: '1', title: 'بيتزا بيبروني', category: 'بيتزا', price: 65, icon: '🍕'),
    Product(id: '2', title: 'ساندوتش شاورما عربي', category: 'شاورما', price: 45, icon: '🌯'),
    Product(id: '3', title: 'ماريا شاورما فراخ', category: 'شاورما', price: 50, icon: '🥙'),
    Product(id: '4', title: 'فطيرة ميكس جبن', category: 'معجنات', price: 55, icon: '🥐'),
    Product(id: '5', title: 'بيتزا تشيكن باربيكيو', category: 'بيتزا', price: 75, icon: '🍕'),
    Product(id: '6', title: 'كومبو التوفير (2 بيتزا + لتر)', category: 'عروض', price: 120, icon: '🎁'),
  ];

  void addToCart(Product p) {
    setState(() {
      cart[p] = (cart[p] ?? 0) + 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة ${p.title} إلى السلة'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF222222),
      ),
    );
  }

  double get totalPrice => cart.entries.fold(0, (sum, e) => sum + (e.key.price * e.value));
  int get totalItemsCount => cart.values.fold(0, (sum, count) => sum + count);

  @override
  Widget build(BuildContext context) {
    final filtered = selectedCategory == 'الكل'
        ? products
        : products.where((p) => p.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB800),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('تيتوس', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 18)),
            ),
            const SizedBox(width: 8),
            const Text('بيتزا ومعجنات وشاورما', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('$totalItemsCount'),
              isLabelVisible: totalItemsCount > 0,
              backgroundColor: const Color(0xFFFFB800),
              textColor: Colors.black,
              child: const Icon(Icons.shopping_bag_outlined, color: Colors.black87),
            ),
            onPressed: () => _openCheckoutBottomSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بانر العرض الذهبي
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB800), Color(0xFFFFA000)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFFFB800).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('عروض التوفير ⚡', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 6),
                          Text('2 بيتزا سوبريم + لتر بيبسي بـ 120 ج.م فقط', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        setState(() => selectedCategory = 'عروض');
                      },
                      child: const Text('طلب العرض', style: TextStyle(color: Colors.white, fontSize: 12)),
                    )
                  ],
                ),
              ),
            ),

            // شريط الأقسام
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = cat == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(cat),
                      selectedColor: const Color(0xFFFFB800),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: Colors.black87,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: isSelected ? Colors.transparent : Colors.black12),
                      ),
                      onSelected: (_) => setState(() => selectedCategory = cat),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // شبكة المنتجات (عمودين)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final p = filtered[index];
                  return Card(
                    color: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 70,
                            alignment: Alignment.center,
                            child: Text(p.icon, style: const TextStyle(fontSize: 48)),
                          ),
                          Text(p.title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${p.price.toInt()} ج.م', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFE59800))),
                              InkWell(
                                onTap: () => addToCart(p),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFB800),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.add, size: 18, color: Colors.black),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: totalItemsCount > 0
          ? Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB800),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _openCheckoutBottomSheet(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('السلة ($totalItemsCount صنف)', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    Text('${totalPrice.toInt()} ج.م  ⬅', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  void _openCheckoutBottomSheet(BuildContext context) {
    final phoneController = TextEditingController();
    final nameController = TextEditingController();
    final addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('إتمام الطلب السريع ⚡', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'رقم الموبايل',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'الاسم',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'العنوان بالتفصيل',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB800),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (phoneController.text.isEmpty) {
                      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('يرجى إدخال رقم الموبايل')));
                      return;
                    }
                    Navigator.pop(ctx);
                    setState(() => cart.clear());
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('تم استلام الطلب! 🍕'),
                        content: const Text('تم إرسال الأوردر للمطبخ مباشرة وبدء التجهيز.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))
                        ],
                      ),
                    );
                  },
                  child: const Text('تأكيد وإرسال للمطبخ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
