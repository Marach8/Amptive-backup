import 'dart:async';
import 'dart:ui';

import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CardData {

  CardData(this.title, this.description, this.pics);
  late String title;
  late String description;
  late String pics;
}

List<CardData> _removedItems = <CardData>[];

final List<CardData> _notifies = <CardData>[
  CardData(
      "The HonestBunch is live now!",
      "Join the live show happening now:\nFrom Ghetto To Glory Featuring Daddy Showkey. Tap to listen and engage.",
      ""),
  CardData(
      "New Subscriber!", "joseph has just subscribed to your channel!", ""),
  CardData(
      "New Payment for The Rest is Football show",
      "dubhem has just paid for access to your event The Rest is Football show.",
      ""),
  CardData("New Follower!", "nonye is now following you. ", ""),
  CardData(
      "New Subscriber!", "joseph has just subscribed to your channel!", ""),
];

class AmptiveNotificationAnimationWidget extends StatefulWidget {
  const AmptiveNotificationAnimationWidget({super.key});

  @override
  State<AmptiveNotificationAnimationWidget> createState() => _AmptiveNotificationAnimationWidgetState();
}

class _AmptiveNotificationAnimationWidgetState extends State<AmptiveNotificationAnimationWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late Timer _timerRemove;

  @override
  void initState() {
    super.initState();
    _timerRemove =
        Timer.periodic(const Duration(seconds: 7), (Timer timer) async {
      await _removeAllItems();
      await Future.delayed(const Duration(milliseconds: 500)); // Small buffer time
      await _addAllItems();
    });
  }

  @override
  void dispose() {
    _timerRemove.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _notifies.length,
              itemBuilder: (BuildContext context, int index, Animation<double> animation) {
                return _buildItem(_notifies[index], animation, index);
              },
            ),
          ),
        ],
      );
  }

  Widget _buildItem(CardData item, Animation<double> animation, int index) {
    double baseWidth = 300.0; // Fixed width for the top card
    double widthReductionFactor =
        20.0; // Reduction in width for each subsequent card

    double width = (index == 0)
        ? baseWidth
        : baseWidth - (index * widthReductionFactor).clamp(0, baseWidth - 50);

    double blurAmount = index * 0.8; // Increase blur by 0.8 for each item

    Tween<Offset> offset = Tween(begin: const Offset(0, -1), end: const Offset(0, 0));


    return SlideTransition(
      position: animation.drive(offset),
      child: Center(
        child: ClipRect(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: blurAmount,
              sigmaY: blurAmount,
            ),
            child: Container(
                width: width.w,
                decoration: index == 0 ? BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: ATColors.transparent,
                      spreadRadius: 10,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ): null,
                margin: EdgeInsets.symmetric(vertical: 5.h),
                child: CardWidget(item, width.w)),
          ),
        ),
      ),
    );
  }

  Future<void> _removeAllItems() async {
    for (int i = _notifies.length - 1; i >= 0; i--) {
      _removeTopNotification();
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  void _removeTopNotification() {
    if (_notifies.isNotEmpty) {
      const int removeIndex = 0;
      CardData removedItem = _notifies.removeAt(removeIndex);
      _removedItems.add(removedItem);
      _listKey.currentState?.removeItem(
        removeIndex,
        (BuildContext context, Animation<double> animation) => _buildItem(removedItem, animation, removeIndex),
        duration: const Duration(milliseconds: 600),
      );
    }
  }

  Future<void> _addAllItems() async {
    for (int i = 0; i < _removedItems.length; i++) {
      _addItem(_removedItems[_removedItems.length - i - 1], 0);
      await Future.delayed(const Duration(milliseconds: 10));
    }
    _removedItems.clear();
  }

  void _addItem(CardData removedItem, int i) {
    _notifies.insert(i, removedItem);
    _listKey.currentState?.insertItem(i);
  }
}

class CardWidget extends StatelessWidget {

  const CardWidget(this.item, this.itemWidth, {super.key});
  final CardData item;
  final double itemWidth;

  @override
  Widget build(BuildContext context) {
    double sf = itemWidth / 300;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11 * sf, vertical: 10.h),
      decoration: ShapeDecoration(
        color: const Color(0xE5242424),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 30 * sf,
            height: 30.w,
            margin: EdgeInsets.only(right: 8 * sf),
            padding: EdgeInsets.all(5 * sf),
            decoration: ShapeDecoration(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.r)),
            ),
            child: SvgPicture.asset(
              ATImgStrings.AMPTIVE_NAME_LOGO,
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 175 * sf,
                          child: Text(
                            item.title,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11.49.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.31,
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox(width: 1.w)),
                        Text(
                          'Just now',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.inter(
                            color: const Color(0xFFC2C2C2),
                            fontSize: 9.96.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 177 * sf,
                        child: Text(
                          item.description,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11.49.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.31,
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox(width: 1.w)),
                      Container(
                        width: 21 * sf,
                        height: 21.w,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage(ATImgStrings.noAvatarImage),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
