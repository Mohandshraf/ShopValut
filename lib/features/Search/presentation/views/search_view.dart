import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopvalut/core/cubits/theme/theme_cubit.dart';
import 'package:shopvalut/core/theme/app_colors.dart';
import 'package:shopvalut/core/theme/theme_extension.dart';
import 'package:shopvalut/features/Home/data/dummy_data.dart';
import 'package:shopvalut/features/Home/data/models/product_model.dart';
import 'package:shopvalut/features/ProductDetails/presentation/views/product_details_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});
  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  bool _searching = false;
  bool _aiLoading = false;
  bool _isAiResult = false;
  List<ProductModel> _results = [];
  String _aiMessage = '';

  final List<String> _recent = ['سماعات', 'Nike shoes', 'ساعة ذكية', 'Sunglasses'];
  final _trending = ['سماعات بلوتوث', 'ساعة ذكية', 'عطر فاخر', 'حقيبة جلد', 'سيروم بشرة', 'حذاء رياضي', 'شاحن لاسلكي', 'مكياج'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  // ── Regular search ──
  void _search(String q) {
    if (q.isEmpty) {
      setState(() { _searching = false; _results = []; _isAiResult = false; _aiMessage = ''; });
      return;
    }
    final all = DummyData.allProducts;
    final lower = q.toLowerCase();
    setState(() {
      _searching = true;
      _isAiResult = false;
      _aiMessage = '';
      _results = all.where((p) {
        return p.name.toLowerCase().contains(lower) ||
            p.category.toLowerCase().contains(lower) ||
            p.tags.any((t) => t.toLowerCase().contains(lower)) ||
            p.description.toLowerCase().contains(lower);
      }).toList();
    });
  }

  // ── AI Smart Search ──
  Future<void> _aiSearch(String query) async {
    if (query.trim().isEmpty) return;
    setState(() { _aiLoading = true; _searching = true; _isAiResult = false; _aiMessage = ''; });

    // Smart local AI matching using tags + description + scoring
    await Future.delayed(const Duration(milliseconds: 800)); // simulate thinking

    final all = DummyData.allProducts;
    final qWords = query.toLowerCase().split(RegExp(r'\s+'));

    // Score each product
    final scored = <ProductModel, int>{};
    for (final p in all) {
      int score = 0;
      final searchable = [
        p.name.toLowerCase(),
        p.description.toLowerCase(),
        p.category.toLowerCase(),
        ...p.tags.map((t) => t.toLowerCase()),
      ].join(' ');

      for (final word in qWords) {
        if (word.length < 2) continue;
        if (p.name.toLowerCase().contains(word)) score += 10;
        if (p.category.toLowerCase().contains(word)) score += 5;
        for (final tag in p.tags) {
          if (tag.toLowerCase().contains(word)) score += 8;
        }
        if (p.description.toLowerCase().contains(word)) score += 3;
        // fuzzy: partial match
        if (searchable.contains(word.substring(0, (word.length * 0.7).round()))) score += 2;
      }

      // Semantic mapping (Arabic ↔ English + synonyms)
      final semanticMap = {
        'سماع': ['headphones', 'audio', 'music', 'wireless'],
        'موسيق': ['headphones', 'audio', 'سماعات'],
        'ساع': ['watch', 'smartwatch', 'time'],
        'رياض': ['sport', 'fitness', 'running', 'sneakers'],
        'موض': ['fashion', 'clothes', 'accessories'],
        'جمال': ['beauty', 'makeup', 'skincare', 'cosmetics'],
        'بشر': ['skincare', 'beauty', 'serum', 'moisturizer'],
        'منزل': ['home', 'decor', 'bedroom'],
        'عطر': ['perfume', 'fragrance', 'oud'],
        'هدي': ['gift', 'present', 'frame', 'candle'],
        'نوم': ['pillow', 'bedsheets', 'sleep', 'comfortable'],
        'شاحن': ['charger', 'wireless', 'phone', 'electronics'],
        'حقيب': ['bag', 'leather', 'accessories'],
        'حذاء': ['shoes', 'sneakers', 'sport'],
        'مكياج': ['makeup', 'beauty', 'cosmetics', 'palette'],
        'ديكور': ['decor', 'home', 'vase', 'candle', 'frame'],
      };

      for (final entry in semanticMap.entries) {
        for (final qWord in qWords) {
          if (qWord.contains(entry.key) || entry.key.contains(qWord)) {
            for (final related in entry.value) {
              if (searchable.contains(related)) score += 6;
            }
          }
        }
      }

      if (score > 0) scored[p] = score;
    }

    final sorted = scored.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final results = sorted.take(8).map((e) => e.key).toList();

    setState(() {
      _aiLoading = false;
      _isAiResult = true;
      _results = results;
      _aiMessage = results.isEmpty
          ? 'لم أجد منتجات مطابقة لـ "$query"'
          : 'وجدت ${results.length} منتج يناسب "$query" 🎯';
    });
  }

  void _tap(String t) {
    _ctrl.text = t;
    _search(t);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, _) {
        return Scaffold(
          backgroundColor: context.bg,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(8),
                // ── Search bar ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: context.card,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: context.border, width: 1.5),
                          ),
                          child: Icon(Icons.arrow_back_ios_new, size: 16, color: context.iconColor),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: TextField(
                          controller: _ctrl,
                          focusNode: _focus,
                          onChanged: _search,
                          onSubmitted: _aiSearch,
                          style: GoogleFonts.outfit(fontSize: 13, color: context.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'ابحث أو اسأل AI...',
                            hintStyle: GoogleFonts.outfit(fontSize: 13, color: context.textHint),
                            prefixIcon: Icon(Icons.search, color: context.textHint, size: 20),
                            suffixIcon: _aiLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(width: 16, height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold)),
                                  )
                                : GestureDetector(
                                    onTap: () => _aiSearch(_ctrl.text),
                                    child: Container(
                                      margin: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [AppColors.gold, Color(0xFFB8865C)]),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ),
                            filled: true,
                            fillColor: context.inputFill,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: context.border, width: 1.5)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: context.border, width: 1.5)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.gold, width: 1.5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                // ── AI hint bar ──
                if (!_searching)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppColors.gold.withValues(alpha: 0.1), AppColors.gold.withValues(alpha: 0.05)]),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: AppColors.gold, size: 14),
                          const Gap(8),
                          Expanded(
                            child: Text(
                              'اضغط ✨ للبحث بالذكاء الاصطناعي — مثلاً: "حاجة للرياضة" أو "هدية للأم"',
                              style: GoogleFonts.outfit(fontSize: 11, color: AppColors.gold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // ── AI result message ──
                if (_isAiResult && _aiMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.green.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: AppColors.green, size: 14),
                          const Gap(8),
                          Expanded(child: Text(_aiMessage, style: GoogleFonts.outfit(fontSize: 12, color: AppColors.green))),
                        ],
                      ),
                    ),
                  ),
                const Gap(8),
                Expanded(child: _searching ? _buildResults() : _buildDefault()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefault() => SingleChildScrollView(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (_recent.isNotEmpty) ...[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Recent', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: context.textPrimary)),
            GestureDetector(
              onTap: () => setState(() => _recent.clear()),
              child: Text('Clear All', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.red)),
            ),
          ]),
        ),
        const Gap(8),
        ...List.generate(_recent.length, (i) => InkWell(
          onTap: () => _tap(_recent[i]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(children: [
              Icon(Icons.access_time, size: 18, color: context.textHint),
              const Gap(14),
              Expanded(child: Text(_recent[i], style: GoogleFonts.outfit(fontSize: 14, color: context.textPrimary))),
              GestureDetector(
                onTap: () => setState(() => _recent.removeAt(i)),
                child: Icon(Icons.close, size: 18, color: context.textHint),
              ),
            ]),
          ),
        )),
        const Gap(16),
      ],
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text('Trending 🔥', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: context.textPrimary)),
      ),
      const Gap(12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Wrap(
          spacing: 8, runSpacing: 8,
          children: _trending.map((t) => GestureDetector(
            onTap: () => _tap(t),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: context.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: context.border, width: 1)),
              child: Text(t, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500, color: context.textPrimary)),
            ),
          )).toList(),
        ),
      ),
      const Gap(30),
    ]),
  );

  Widget _buildResults() {
    if (_aiLoading) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2.5),
          const Gap(16),
          Text('AI يبحث عن أفضل النتائج...', style: GoogleFonts.outfit(fontSize: 14, color: context.textHint)),
        ]),
      );
    }
    if (_results.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.search_off, size: 60, color: context.border),
          const Gap(12),
          Text('No products found', style: GoogleFonts.outfit(fontSize: 16, color: context.textHint)),
          const Gap(8),
          Text('جرب الضغط على ✨ للبحث بالذكاء الاصطناعي', style: GoogleFonts.outfit(fontSize: 12, color: context.textHint)),
        ]),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.72,
      ),
      itemCount: _results.length,
      itemBuilder: (_, i) {
        final p = _results[i];
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsView(product: p))),
          child: Container(
            decoration: BoxDecoration(color: context.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.border, width: 1)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 1.1,
                    child: Image.network(p.imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(color: context.shimmer,
                        child: Center(child: Icon(Icons.image_outlined, size: 40, color: context.border)))),
                  ),
                ),
                Positioned(top: 8, left: 8, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(8)),
                  child: Text('-${p.discount}%', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                )),
                if (_isAiResult)
                  Positioned(top: 8, right: 8, child: Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.gold, Color(0xFFB8865C)]),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                  )),
              ]),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary)),
                  const Gap(3),
                  Row(children: [
                    const Icon(Icons.star, size: 12, color: Color(0xFFFFB800)),
                    const Gap(3),
                    Text('${p.rating} (${p.reviews})', style: GoogleFonts.outfit(fontSize: 10, color: context.textSecondary)),
                  ]),
                  const Gap(4),
                  Row(children: [
                    Text('\$${p.price}', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.green)),
                    const Gap(4),
                    Flexible(child: Text('\$${p.oldPrice}', style: GoogleFonts.outfit(fontSize: 10, color: context.textHint, decoration: TextDecoration.lineThrough), overflow: TextOverflow.ellipsis)),
                  ]),
                ]),
              ),
            ]),
          ),
        );
      },
    );
  }
}
