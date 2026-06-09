import 'dart:async' show Timer;
import 'dart:developer' show log;
import 'dart:ui';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/post_auth/presentation/widgets/slide_out_widget.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../../../post_auth/presentation/widgets/notification_card_widget.dart';

class NotificationsPromptScreen extends StatelessWidget {
  const NotificationsPromptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SlideOutBloc>(
        create: (_) => SlideOutBloc(), child: const _SubWidget());
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget();

  @override
  State<_SubWidget> createState() => _AnimExperimentState();
}

class _AnimExperimentState extends State<_SubWidget>
    with TickerProviderStateMixin {
  static final List<
          ({String title, String description, String trailingPic, String time})>
      _originalItems =
      <({String title, String description, String trailingPic, String time})>[
    (
      title: ATStrings.NOTIF1,
      description: ATStrings.NOTIF1_DESC,
      trailingPic: ATImgStrings.ONBOARD_NOTIF_IMG1,
      time: 'Just now',
    ),
    (
      title: ATStrings.NOTIF2,
      description: ATStrings.NOTIF2_DESC,
      trailingPic: ATImgStrings.ONBOARD_NOTIF_IMG2,
      time: '1m ago',
    ),
    (
      title: ATStrings.NOTIF3,
      description: ATStrings.NOTIF3_DESC,
      trailingPic: ATImgStrings.ONBOARD_NOTIF_IMG3,
      time: '5m ago',
    ),
    (
      title: ATStrings.NOTIF4,
      description: ATStrings.NOTIF4_DESC,
      trailingPic: ATImgStrings.ONBOARD_NOTIF_IMG4,
      time: '8m ago',
    ),
    (
      title: ATStrings.NOTIF5,
      description: ATStrings.NOTIF5_DESC,
      trailingPic: ATImgStrings.ONBOARD_NOTIF_IMG5,
      time: '10m ago',
    ),
    (
      title: ATStrings.NOTIF6,
      description: ATStrings.NOTIF6_DESC,
      trailingPic: ATImgStrings.ONBOARD_NOTIF_IMG6,
      time: '11m ago',
    ),
    (
      title: ATStrings.NOTIF7,
      description: ATStrings.NOTIF7_DESC,
      trailingPic: ATImgStrings.ONBOARD_NOTIF_IMG7,
      time: '15m ago',
    ),
  ];

  final GlobalKey<AnimatedListState> _animListKey =
      GlobalKey<AnimatedListState>();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final ScrollController _scrollCntrl = ScrollController();
  late final Timer _timer;
  static const double _rightPicSize = 20;
  static const double _leftPicSize = 30;
  static const double _normalTitleFontSize = 12;
  static const double _normalTrailingFontSize = 10;
  static const int _slideOutDuration = 800;
  static const double _baseHeigth = 130.0;

  void addItem(
      ({
        String title,
        String description,
        String trailingPic,
        String time
      }) item) {
    final int index = _originalItems.length;
    _originalItems.add(item);
    _animListKey.currentState?.insertItem(index);
  }

  void _removeFirstItemAndAppendToEnd() {
    if (_originalItems.isEmpty) return;

    final ({
      String title,
      String description,
      String trailingPic,
      String time
    }) removedItem = _originalItems.first;
    _originalItems.removeAt(0);

    _animListKey.currentState?.removeItem(
      0,
      (_, Animation<double> animation) {
        return Opacity(
          opacity: 0.0,
          child: SizeTransition(
            sizeFactor: animation,
            child: NotifTile1(
              horizMargin: 10,
              leftPicSize: _leftPicSize,
              rightPicSize: _rightPicSize,
              titleFontSize: _normalTitleFontSize,
              subTitleFontSize: _normalTitleFontSize,
              timeFontSize: _normalTrailingFontSize,
              title: removedItem.title,
              time: removedItem.time,
              rightImgPath: removedItem.trailingPic,
              subtitle: removedItem.description,
            ),
          ),
        );
      },
      duration: const Duration(milliseconds: _slideOutDuration),
    );

    context.read<SlideOutBloc>().showItem();
    context.read<SlideOutBloc>().kickOffSliding();

    Future<void>.delayed(const Duration(milliseconds: _slideOutDuration), () {
      if (mounted) {
        context.read<SlideOutBloc>().addNotification(NotifParams(
            title: _originalItems.elementAt(0).title,
            desc: _originalItems.elementAt(0).description,
            time: _originalItems.elementAt(0).time,
            trailingPic: _originalItems.elementAt(0).trailingPic));
      }
      addItem(removedItem);
    });
  }

  void _kickOffAnimation() {
    _timer = Timer.periodic(
      const Duration(milliseconds: _slideOutDuration + 500),
      (_) => _removeFirstItemAndAppendToEnd(),
    );
  }

  void _precacheImages() {
    for (({
      String title,
      String description,
      String trailingPic,
      String time
    }) item in _originalItems) {
      precacheImage(
        AssetImage(item.trailingPic),
        context,
        onError: (Object e, StackTrace? w) => log('$e, $w'),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      if (mounted) {
        _precacheImages();
        context.read<SlideOutBloc>().addNotification(NotifParams(
            title: _originalItems.elementAt(0).title,
            desc: _originalItems.elementAt(0).description,
            time: _originalItems.elementAt(0).time,
            trailingPic: _originalItems.elementAt(0).trailingPic));
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _kickOffAnimation());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
                top: 0,
                left: -100,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                  child: const ATImgLoader(
                    imgPath: ATImgStrings.BLUE_ROTOR_IMG,
                    height: 400,
                    width: 400,
                  ),
                )),
            Positioned(
                right: -150,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: const ATImgLoader(
                    imgPath: ATImgStrings.ROTOR_IMG,
                    height: 300,
                    width: 300,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight * 1.5),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 120,
                    width: 250,
                    child: Text(
                      ATStrings.stayOnTheLoop,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineMedium?.copyWith(
                          fontSize: 45, fontWeight: ATFontWeights.w800),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                    child: Text(ATStrings.ALLOW_NOTIFICATIONS,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: context.textTheme.bodySmall),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                        width: context.screenWidth * 0.85,
                        decoration: BoxDecoration(
                          color: ATColors.hex0D0D0D.withValues(alpha: 0.71),
                          border: Border.all(
                              width: 5,
                              color: ATColors.hex323033.withValues(alpha: 0.3)),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              AnimatedList(
                                padding: const EdgeInsets.fromLTRB(
                                    0, _baseHeigth, 0, 20),
                                key: _animListKey,
                                controller: _scrollCntrl,
                                physics: const NeverScrollableScrollPhysics(),
                                initialItemCount: _originalItems.length,
                                itemBuilder:
                                    (_, int index, Animation<double> anim) {
                                  final ({
                                    String title,
                                    String description,
                                    String trailingPic,
                                    String time
                                  }) item = _originalItems.elementAt(index);
                                  final double scale = 1.0 - (0.1 * index);

                                  return SizeTransition(
                                    sizeFactor: anim,
                                    child: NotifTile1(
                                      horizMargin: (index * 8) + 10,
                                      leftPicSize: _leftPicSize * scale,
                                      rightPicSize: _rightPicSize * scale,
                                      titleFontSize:
                                          _normalTitleFontSize * scale,
                                      subTitleFontSize:
                                          _normalTitleFontSize * scale,
                                      timeFontSize:
                                          _normalTrailingFontSize * scale,
                                      time: item.time,
                                      title: item.title,
                                      subtitle: item.description,
                                      rightImgPath: item.trailingPic,
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                  top: 20,
                                  child: ATContainer(
                                    width: 80,
                                    height: 18,
                                    color: ATColors.hex2F2F2F,
                                    radius: 30,
                                  )),
                              const SlideOutWidget(
                                duration: _slideOutDuration,
                              )
                            ])),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.7, sigmaY: 0.7),
                  child: SizedBox(height: 220, width: context.screenWidth),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              child: ATContainer(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                width: context.screenWidth - 30.0,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      ATColors.hex0D0D0D,
                      ATColors.hex0D0D0D.withValues(alpha: 0.9)
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 15,
                  children: <Widget>[
                    ATPlainElevatedBtn(
                      onPressed: () {
                        storage.write(
                            key: ATStrings.isExistingUser, value: 'true');
                        context.goNamed(ATRoutes.dashboard);
                      },
                      btnTitle: ATStrings.allow,
                    ),
                    InkWell(
                        onTap: () {
                          storage.write(
                              key: ATStrings.isExistingUser,
                              value: 'true');
                          context.goNamed(ATRoutes.dashboard);
                        },
                        borderRadius: BorderRadius.circular(5),
                        child: Text(
                          ATStrings.NO_THANKS,
                          style: context.textTheme.bodyLarge
                              ?.copyWith(fontSize: ATSizes.size17),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
