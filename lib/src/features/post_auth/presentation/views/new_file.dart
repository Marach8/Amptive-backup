
import 'dart:async';
import 'dart:developer' show log;
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';


class AnimExperiment extends StatefulWidget {
  const AnimExperiment({super.key});

  @override
  State<AnimExperiment> createState() => _AnimExperimentState();
}

class _AnimExperimentState extends State<AnimExperiment> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  int? _removingIndex;

  final List<({String title, String description})> _originalItems = <({String title, String description})>[
    (
      title: 'Anything you want make you do',
      description: 'The power of desire is immense, capable of driving individuals to achieve extraordinary feats or, conversely, lead them astray.'
    ),
    (
      title: 'How you go talk like that',
      description: 'The'
    ),
    (
      title: 'Did I call you to come?',
      description: 'Uninvited presence can sometimes lead to awkward situations, highlighting the importance of clear invitations and boundaries.'
    ),
    (
      title: 'Nwanne mind your biznaess',
      description: 'In many'
    ),
    (
      title: 'As far as then no kill God',
      description: 'This phrase suggests a profound sense of resilience',
    ),
    (
      title: 'You are good in the name',
      description: 'A compliment suggesting proficiency or skill, often implying that someone lives up to their reputation or the expectations associated with their identity.'
    ),
  ];

  late List<({String title, String description})> _items;
  late List<GlobalKey> _notifItemKeys;
  late List<double> _notifItemsPositon4rmTop;
  static const double _baseHeight = 150;
  static const double _normalPicSize = 30;
  static const double _normalTitleFontSize = 12;
  static const double _normalTrailingFontSize = 10;
  Timer? _timer;
  bool _isResetting = false;
  ({String title, String description})? _lastSurvivor;
  late final AnimationController _rainingController;
  late final Animation<double> _rainingAnimation;

  @override
  void initState(){
    super.initState();
    _items = List.from(_originalItems);
    _notifItemKeys = List<GlobalKey>.generate(_items.length, (_) => GlobalKey());
    _notifItemsPositon4rmTop = List<double>.filled(_items.length, 0.0, growable: true);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _items.removeAt(0);
          _notifItemKeys.removeAt(0);
          _notifItemsPositon4rmTop.removeAt(0);
          _removingIndex = null;
          _animationController.reset();
          _initializePositions4rmTop();
        });
      }
    });

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    )..addListener(() {
      setState(() {});
    });

    _rainingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _rainingAnimation = CurvedAnimation(
      parent: _rainingController,
      curve: Curves.bounceOut,
    )..addListener(() {
      setState(() {});
    });
  }

  void _startRainingAnimation() {
    setState(() {
      _isResetting = true;
      _items = List.from(_originalItems);
      _notifItemKeys.clear();
      _notifItemKeys.addAll(List<GlobalKey>.generate(_items.length, (_) => GlobalKey()));
      _notifItemsPositon4rmTop = List<double>.filled(_items.length, 0.0, growable: true);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePositions4rmTop();
      _rainingController.forward(from: 0.0).whenComplete(() {
        setState(() {
          _isResetting = false;
          _lastSurvivor = null;
        });
      });
    });
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializePositions4rmTop());
  }

  void _initializePositions4rmTop(){
    double cumulativeHeight = _baseHeight;

    for (int i = 0; i < _notifItemKeys.length; i++) {
      final BuildContext? context = _notifItemKeys[i].currentContext;
      if (context == null) {
        _notifItemsPositon4rmTop[i] = cumulativeHeight;
        continue;
      }

      final RenderBox box = context.findRenderObject() as RenderBox;
      final double itemHeight = box.size.height;
      _notifItemsPositon4rmTop[i] = cumulativeHeight;
      cumulativeHeight += itemHeight;
    }

    if(mounted){setState(() {});}
  }

  void _startAutoRemoval() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _removeFirstItem();
    });
  }

  void _removeFirstItem() {
    if (_animationController.isAnimating || _items.isEmpty) return;

    if (_items.length > 1) {
      setState(() {
        _removingIndex = 0;
      });
      _animationController.forward();
    } else {
      _timer?.cancel();
      _lastSurvivor = _items[0];
      _startRainingAnimation();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rainingController.dispose();
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    log('--------------------------------');
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _startAutoRemoval,
              child: const Text('Start Animation'),
            ),
            Text(
              'STAY ON THE LOOP', maxLines: 2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 45,
                fontWeight: ATFontWeights.w800
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Text(
                'Allow Amptive to send notifications of live audio shows & events ',
                textAlign: TextAlign.center,
                maxLines: 3,
                style: Theme.of(context).textTheme.bodySmall
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: context.screenWidth * 0.85,
                  clipBehavior: Clip.antiAlias,
                  decoration: const ShapeDecoration(
                    color: Color(0xB50C0C0C),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 5, color: Color(0x4C323033)),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    shadows: <BoxShadow>[
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                    Positioned(
                      top: 20,
                      child: ATContainer(
                        width: 80, height: 18,
                        color: ATColors.hex2F2F2F,
                        radius: 30,
                      )
                    ),
                                
                    ..._items.asMap().entries.map(
                      (MapEntry<int, ({String description, String title})> entry) {
                        final int index = entry.key;
                        final ({String description, String title}) item = entry.value;
                                
                        final bool isRemoving = index == _removingIndex;
                        double topPosition;
                                
                        if (_isResetting) {
                          double initialY;
                          if (_lastSurvivor != null && item.title == _lastSurvivor!.title && item.description == _lastSurvivor!.description) {
                            initialY = _baseHeight;
                          } else {
                            initialY = -500.0;
                          }
                          final double finalY = _notifItemsPositon4rmTop.isNotEmpty ? _notifItemsPositon4rmTop[index] : _baseHeight;
                          topPosition = initialY + (finalY - initialY) * _rainingAnimation.value;
                        } else {
                          topPosition = isRemoving
                              ? _notifItemsPositon4rmTop[index] - (150 * _animation.value)
                              : (_notifItemsPositon4rmTop.isNotEmpty ? _notifItemsPositon4rmTop[index] : _baseHeight);
                        }
                                
                        return AnimatedPositioned(
                          duration: isRemoving ? Duration.zero : const Duration(milliseconds: 500),
                          left: isRemoving
                              ? ((index * 8) + 10) + (50 * _animation.value)
                              : (index * 8) + 10,
                          right: isRemoving
                              ? ((index * 8) + 10) + (50 * _animation.value)
                              : (index * 8) + 10,
                          key: _notifItemKeys[index],
                          top: topPosition,
                          child: NotificationListener<SizeChangedLayoutNotification>(
                            onNotification: (SizeChangedLayoutNotification notification){
                              WidgetsBinding.instance.addPostFrameCallback((_) => _initializePositions4rmTop());
                              return true;
                            },
                            child: SizeChangedLayoutNotifier(
                              child: NotifTile(
                                pictureSize: _normalPicSize * (1.0 - (0.1 * index)),
                                titleFontSize: _normalTitleFontSize * (1.0 - (0.1 * index)),
                                subTitleFontSize: _normalTitleFontSize * (1.0 - (0.1 * index)),
                                timeFontSize: _normalTrailingFontSize * (1.0 - (0.1 * index)),
                                title: item.title,
                                subtitle: item.description,
                              ),
                            ),
                          ),
                        );
                      }
                    )
                  ]
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotifTile extends StatelessWidget {
  const NotifTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.pictureSize,
    required this.timeFontSize,
    required this.subTitleFontSize,
    required this.titleFontSize,
    this.onTap
  });

  final String title, subtitle;
  final VoidCallback? onTap;
  final double pictureSize,
  titleFontSize, subTitleFontSize, timeFontSize;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      color: ATColors.hex252525.withValues(alpha: 0.9),
      radius: 14,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ATContainer(
            radius: 5,
            height: pictureSize,
            clipBehavior: Clip.hardEdge,
            width: pictureSize,
            child: const ATImgLoader(
              imgPath: ATImgStrings.jpeg1,
              boxFit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 500),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: titleFontSize
                  ),
                  child: Text(title),
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 500),
                  maxLines: 4, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: subTitleFontSize,
                  ),
                  child: Text(subtitle,),
                )
              ],
            ),
          ),
          const SizedBox(width: 8,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 500),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: timeFontSize,
                  color: ATColors.hexC2C2C2
                ),
                child: const Text('08:00 am'),
              ),
              const SizedBox(height: 2,),
              ATContainer(
                radius: 5,
                clipBehavior: Clip.hardEdge,
                height: pictureSize,
                width: pictureSize,
                child: const ATImgLoader(
                  imgPath: ATImgStrings.jpeg2,
                  boxFit: BoxFit.cover,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

