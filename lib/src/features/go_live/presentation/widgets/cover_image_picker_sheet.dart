import 'dart:math' as math;
import 'dart:ui';

import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CoverImagePickerResult {
  const CoverImagePickerResult.asset(this.assetPath) : source = null;
  const CoverImagePickerResult.library()
      : assetPath = null,
        source = ImageSource.gallery;

  final String? assetPath;
  final ImageSource? source;
}

typedef _CoverTemplate = ({String category, String image, String title});

const List<_CoverTemplate> _coverTemplates = <_CoverTemplate>[
  (
    title: 'Business',
    category: 'Business',
    image: 'assets/images/png_images/gallery/business/money-flower.png'
  ),
  (
    title: 'Business',
    category: 'Business',
    image: 'assets/images/png_images/gallery/business/watering-money-growth.png'
  ),
  (
    title: 'Business',
    category: 'Business',
    image: 'assets/images/png_images/gallery/business/growth-chart-hands.png'
  ),
  (
    title: 'Business',
    category: 'Business',
    image: 'assets/images/png_images/gallery/business/strategy-notes-head.png'
  ),
  (
    title: 'Business',
    category: 'Business',
    image: 'assets/images/png_images/gallery/business/team-lightbulb.png'
  ),
  (
    title: 'Business',
    category: 'Business',
    image: 'assets/images/png_images/gallery/business/team-pie-chart.png'
  ),
  (
    title: 'Business',
    category: 'Business',
    image: 'assets/images/png_images/gallery/business/build-letters.png'
  ),
  (
    title: 'Business',
    category: 'Business',
    image: 'assets/images/png_images/gallery/business/network-person.png'
  ),
  (
    title: 'Business',
    category: 'Business',
    image:
        'assets/images/png_images/gallery/business/upward-arrow-breakthrough.png'
  ),
  (
    title: 'Business',
    category: 'Business',
    image: 'assets/images/png_images/gallery/business/strategy-mountain.png'
  ),
  (
    title: 'Business',
    category: 'Business',
    image: 'assets/images/png_images/gallery/business/coin-stair-growth.png'
  ),
  (
    title: 'Tech',
    category: 'Tech',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/yd/c8ded50f-24e7-4af0-aeb2-9bac97712e4c.png'
  ),
  (
    title: 'Tech',
    category: 'Tech',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/x4/232b7986-33f1-4753-928d-84910cd55dd8.png'
  ),
  (
    title: 'Tech',
    category: 'Tech',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/sx/81dcf961-c47a-4474-a332-2640c211ac3e.png'
  ),
  (
    title: 'Tech',
    category: 'Tech',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/ve/ab94b70b-d954-410a-b686-1a32c74a4d75.png'
  ),
  (
    title: 'Party',
    category: 'Party',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/vt/318de18d-3cb8-4b4e-ae3b-60e03f671ee2.png'
  ),
  (
    title: 'Party',
    category: 'Party',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/qk/a33323fb-d69b-45c5-9362-3a49dc9b4cbc.png'
  ),
  (
    title: 'Party',
    category: 'Party',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/di/5eed6028-6641-4564-8544-731c4d29371e.png'
  ),
  (
    title: 'Party',
    category: 'Party',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/u1/3ad47c7f-bae0-4396-aa9f-29522aab4084.png'
  ),
  (
    title: 'Music',
    category: 'Music',
    image:
        'https://images.pexels.com/photos/1190298/pexels-photo-1190298.jpeg?auto=compress&cs=tinysrgb&w=800'
  ),
  (
    title: 'Music',
    category: 'Music',
    image:
        'https://images.pexels.com/photos/2747449/pexels-photo-2747449.jpeg?auto=compress&cs=tinysrgb&w=800'
  ),
  (
    title: 'Music',
    category: 'Music',
    image:
        'https://images.pexels.com/photos/1105666/pexels-photo-1105666.jpeg?auto=compress&cs=tinysrgb&w=800'
  ),
  (
    title: 'Music',
    category: 'Music',
    image:
        'https://images.pexels.com/photos/2263436/pexels-photo-2263436.jpeg?auto=compress&cs=tinysrgb&w=800'
  ),
  (
    title: 'Sports',
    category: 'Sports',
    image: 'assets/images/png_images/gallery/sports/football-classic.png'
  ),
  (
    title: 'Sports',
    category: 'Sports',
    image: 'assets/images/png_images/gallery/sports/run-with-us.png'
  ),
  (
    title: 'Sports',
    category: 'Sports',
    image: 'assets/images/png_images/gallery/sports/formula-watch-party.png'
  ),
  (
    title: 'Sports',
    category: 'Sports',
    image: 'assets/images/png_images/gallery/sports/speed-is-everything.png'
  ),
  (
    title: 'Sports',
    category: 'Sports',
    image: 'assets/images/png_images/gallery/sports/f1-speed.png'
  ),
  (
    title: 'Sports',
    category: 'Sports',
    image: 'assets/images/png_images/gallery/sports/f1-front-dark.png'
  ),
  (
    title: 'Sports',
    category: 'Sports',
    image: 'assets/images/png_images/gallery/sports/f1-distant-dark.png'
  ),
  (
    title: 'Sports',
    category: 'Sports',
    image: 'assets/images/png_images/gallery/sports/f1-red-line.png'
  ),
  (
    title: 'Sports',
    category: 'Sports',
    image: 'assets/images/png_images/gallery/sports/f1-red-glow.png'
  ),
  (
    title: 'Sports',
    category: 'Sports',
    image: 'assets/images/png_images/gallery/sports/race-weekend.png'
  ),
  (
    title: 'Sports',
    category: 'Sports',
    image: 'assets/images/png_images/gallery/sports/goal-green.png'
  ),
  (
    title: 'Sports',
    category: 'Sports',
    image: 'assets/images/png_images/gallery/sports/game-day.png'
  ),
  (
    title: 'Sports',
    category: 'Sports',
    image: 'assets/images/png_images/gallery/sports/football-neon.png'
  ),
  (
    title: 'School',
    category: 'School',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/qz/95e54594-3503-4a28-96be-a84452f1d13b.png'
  ),
  (
    title: 'School',
    category: 'School',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/an/1a84247d-82e8-4605-867d-5231fd102404.png'
  ),
  (
    title: 'School',
    category: 'School',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/6s/4151ebf4-08f7-454f-ad5f-a584cdda0619.png'
  ),
  (
    title: 'School',
    category: 'School',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/45/c841ec5a-04b9-4ea4-9bc1-6c6d94b1ae48'
  ),
  (
    title: 'Invitations',
    category: 'Invitations',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/1y/9ba31350-4f83-4d92-b6af-adfc0da51d82.png'
  ),
  (
    title: 'Invitations',
    category: 'Invitations',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/17/53eb7aa8-96be-4ea7-b52e-da82c82c445c.png'
  ),
  (
    title: 'Invitations',
    category: 'Invitations',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/mn/1f9bb9ed-4d81-47da-b62e-74320ef3b85a.png'
  ),
  (
    title: 'Women',
    category: 'Women',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/3b/bb4d566a-1780-43d2-ade8-ca82fa8b9986.png'
  ),
  (
    title: 'Women',
    category: 'Women',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/02/7f5096be-e7ee-4631-b699-d215d4f3818d.png'
  ),
  (
    title: 'Women',
    category: 'Women',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/yf/e6c839a1-a1f9-4187-afca-5a539862338d.png'
  ),
  (
    title: 'Women',
    category: 'Women',
    image:
        'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=2,anim=false,background=white,quality=75,width=600,height=600/gallery-images/nn/8ce964b2-0ce2-4cfd-b26e-2a9c25ce2695.png'
  ),
];

/// A random curated cover, used to pre-fill new show/event forms so they
/// never start with a bare placeholder.
String randomCoverTemplateImage() =>
    _coverTemplates[math.Random().nextInt(_coverTemplates.length)].image;

Future<CoverImagePickerResult?> showCoverImagePickerSheet(
  BuildContext context, {
  required ValueChanged<String> onCoverSelected,
}) {
  return showModalBottomSheet<CoverImagePickerResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.94,
      child: _CoverImagePickerSheet(
        onCoverSelected: onCoverSelected,
      ),
    ),
  );
}

class _CoverImagePickerSheet extends StatefulWidget {
  const _CoverImagePickerSheet({required this.onCoverSelected});

  final ValueChanged<String> onCoverSelected;

  @override
  State<_CoverImagePickerSheet> createState() => _CoverImagePickerSheetState();
}

class _CoverImagePickerSheetState extends State<_CoverImagePickerSheet> {
  static const List<String> _categories = <String>[
    'Browse',
    'Business',
    'Tech',
    'Party',
    'Music',
    'Sports',
    'School',
    'Invitations',
    'Women',
  ];

  /// Categories whose network images have already been precached this session.
  static final Set<String> _precachedCategories = <String>{};

  String _selectedCategory = 'Browse';
  bool _imagesReady = false;

  List<_CoverTemplate> get _visibleTemplates {
    if (_selectedCategory == 'Browse') {
      return <_CoverTemplate>[
        for (final String category in _categories.skip(1))
          _coverTemplates
              .firstWhere((_CoverTemplate item) => item.category == category),
      ];
    }
    return _coverTemplates.where((_CoverTemplate template) {
      return template.category == _selectedCategory;
    }).toList();
  }

  bool _didInitialPrecache = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // precacheImage needs an active context, which isn't available yet in
    // initState — this is the earliest safe place to kick it off.
    if (!_didInitialPrecache) {
      _didInitialPrecache = true;
      _precacheCategory();
    }
  }

  void _precacheCategory() {
    if (_precachedCategories.contains(_selectedCategory)) {
      _imagesReady = true;
      return;
    }

    _imagesReady = false;

    final List<_CoverTemplate> templates = _visibleTemplates;
    final List<String> networkUrls = templates
        .map((_CoverTemplate t) => t.image)
        .where((String img) => img.startsWith('http'))
        .toList();

    if (networkUrls.isEmpty) {
      _imagesReady = true;
      return;
    }

    int loaded = 0;
    for (final String url in networkUrls) {
      // CachedNetworkImageProvider stores the file on disk, so covers only
      // ever download once — later opens read them straight from storage.
      precacheImage(CachedNetworkImageProvider(url), context).then((_) {
        loaded++;
        if (loaded >= networkUrls.length && mounted) {
          _precachedCategories.add(_selectedCategory);
          setState(() => _imagesReady = true);
        }
      }).catchError((_) {
        loaded++;
        if (loaded >= networkUrls.length && mounted) {
          _precachedCategories.add(_selectedCategory);
          setState(() => _imagesReady = true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<_CoverTemplate> templates = _visibleTemplates;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: Material(
        color: const Color(0xFF1C1C1E),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Container(
              width: 38,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            _buildHeader(context),
            _buildCategories(),
            const SizedBox(height: 8),
            Divider(height: 1, color: Colors.white.withValues(alpha: 0.1)),
            Expanded(
              child: Stack(
                children: <Widget>[
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.025, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: templates.isEmpty
                        ? const Center(
                            key: ValueKey<String>('empty'),
                            child: Text('No cover images found'),
                          )
                        : _imagesReady
                            ? GridView.builder(
                                key: ValueKey<String>(
                                    '${_selectedCategory}_loaded'),
                                padding: const EdgeInsets.fromLTRB(
                                    16, 20, 16, 112),
                                physics: const ClampingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                  childAspectRatio: 0.9,
                                ),
                                itemCount: templates.length,
                                itemBuilder: (_, int index) {
                                  final _CoverTemplate template =
                                      templates[index];
                                  return _CoverTemplateTile(
                                    template: template,
                                    isCatalogue:
                                        _selectedCategory == 'Browse',
                                    onTap: _selectedCategory == 'Browse'
                                        ? () {
                                            setState(() =>
                                                _selectedCategory =
                                                    template.category);
                                            _precacheCategory();
                                          }
                                        : () {
                                            widget.onCoverSelected(
                                                template.image);
                                            Navigator.pop(context);
                                          },
                                  );
                                },
                              )
                            : GridView.builder(
                                key: ValueKey<String>(
                                    '${_selectedCategory}_shimmer'),
                                padding: const EdgeInsets.fromLTRB(
                                    16, 20, 16, 112),
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                  childAspectRatio: 0.9,
                                ),
                                itemCount: templates.length,
                                itemBuilder: (_, __) =>
                                    const _ShimmerTile(),
                              ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          color:
                              const Color(0xFF1C1C1E).withValues(alpha: 0.58),
                          child: SafeArea(
                            top: false,
                            minimum: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                            child: SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(
                                  context,
                                  const CoverImagePickerResult.library(),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: const StadiumBorder(),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: const Text('Choose From Library'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: const Icon(Icons.close, size: 28),
            ),
          ),
          Text(
            'Add Cover Image',
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.39,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: _categories.length,
        itemBuilder: (_, int index) {
          final String category = _categories[index];
          final bool selected = category == _selectedCategory;
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 15 : 0, right: 10),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                    setState(() => _selectedCategory = category);
                    _precacheCategory();
                  },
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white
                        : const Color(0xFF9E9E9E).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        _categoryIcon(category),
                        size: 16,
                        color:
                            selected ? const Color(0xFF0D0D0D) : Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        category,
                        style: context.textTheme.bodySmall?.copyWith(
                          color:
                              selected ? const Color(0xFF0D0D0D) : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _categoryIcon(String category) {
    return switch (category) {
      'Browse' => Icons.grid_view_rounded,
      'Business' => Icons.business_center_outlined,
      'Tech' => Icons.memory,
      'Party' => Icons.celebration_outlined,
      'Music' => Icons.music_note_rounded,
      'Sports' => Icons.sports_soccer,
      'School' => Icons.school_outlined,
      'Invitations' => Icons.mail_outline_rounded,
      'Women' => Icons.woman_rounded,
      _ => Icons.category_outlined,
    };
  }
}

class _CoverTemplateTile extends StatelessWidget {
  const _CoverTemplateTile({
    required this.template,
    required this.isCatalogue,
    required this.onTap,
  });

  final _CoverTemplate template;
  final bool isCatalogue;
  final VoidCallback onTap;

  List<String> get _stackImages {
    final List<String> categoryImages = _coverTemplates
        .where((_CoverTemplate item) => item.category == template.category)
        .map((_CoverTemplate item) => item.image)
        .take(4)
        .toList();
    while (categoryImages.length < 4) {
      categoryImages.add(categoryImages.last);
    }
    return categoryImages;
  }

  @override
  Widget build(BuildContext context) {
    return ClipSmoothRect(
      radius: SmoothBorderRadius(cornerRadius: 16, cornerSmoothing: 0.8),
      child: Material(
        color: const Color(0xFF2A2A2D),
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white.withValues(alpha: 0.06),
          highlightColor: Colors.white.withValues(alpha: 0.03),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ClipSmoothRect(
                    radius: SmoothBorderRadius(
                      cornerRadius: 12,
                      cornerSmoothing: 0.8,
                    ),
                    child: Container(
                      height: 128,
                      color: const Color(0xFF18181B),
                      child: isCatalogue
                          ? Stack(
                              alignment: Alignment.center,
                              children: List<Widget>.generate(
                                _stackImages.length,
                                (int index) => _StackedCoverImage(
                                  imagePath: _stackImages[index],
                                  index: index,
                                ),
                              ),
                            )
                          : _CoverImage(
                              imagePath: template.image,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isCatalogue ? template.category : 'Select cover',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFC2C2C2),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StackedCoverImage extends StatelessWidget {
  const _StackedCoverImage({required this.imagePath, required this.index});

  final String imagePath;
  final int index;

  static const List<double> _offsets = <double>[-24, -18, -12, -6];
  static const List<double> _widthFactors = <double>[0.6, 0.68, 0.76, 0.84];

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Transform.translate(
          offset: Offset(0, _offsets[index]),
          child: FractionallySizedBox(
            widthFactor: _widthFactors[index],
            child: SizedBox(
              height: 84,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: _CoverImage(imagePath: imagePath, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerTile extends StatelessWidget {
  const _ShimmerTile();

  @override
  Widget build(BuildContext context) {
    return ClipSmoothRect(
      radius: SmoothBorderRadius(cornerRadius: 16, cornerSmoothing: 0.8),
      child: const ATShimmer(
        height: double.infinity,
        width: double.infinity,
        radius: 16,
        baseColor: Color(0xFF2A2A2D),
        highlightColor: Color(0xFF3D3D42),
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.imagePath, required this.fit});

  final String imagePath;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        errorWidget: (_, __, ___) => const ColoredBox(
          color: Color(0xFF2A2A2D),
          child: Center(child: Icon(Icons.image_not_supported_outlined)),
        ),
      );
    }
    return Image.asset(
      imagePath,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
