import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CardData {
  late String title;
  late String description;
  late String pics;

  CardData(this.title, this.description, this.pics);
}

class PreHomePage extends StatefulWidget {
  const PreHomePage({Key? key}) : super(key: key);

  @override
  State<PreHomePage> createState() => _PreHomePageState();
}

class _PreHomePageState extends State<PreHomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final List<CardData> _notifies = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Cards'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _notifies.length,
              itemBuilder: (context, index, animation) {
                return _buildItem(_notifies[index], animation, index);
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _removeTopNotification(),
            child: Text('Remove Top Notification'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildItem(CardData item, Animation<double> animation, int index) {
    double baseWidth = 300.0; // Fixed width for the top card
    double widthReductionFactor =
        20.0; // Reduction in width for each subsequent card

    double width = (index == 0)
        ? baseWidth
        : baseWidth - (index * widthReductionFactor).clamp(0, baseWidth - 50);

    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: Center(
        child: Container(
            width: width.w,
            margin: EdgeInsets.symmetric(vertical: 5.h),
            child: CardWidget(item, width.w)),
      ),
    );
  }

  void _removeTopNotification() {
    if (_notifies.isNotEmpty) {
      final int removeIndex = 0;
      CardData removedItem = _notifies.removeAt(removeIndex);
      _listKey.currentState?.removeItem(
        removeIndex,
        (context, animation) => _buildItem(removedItem, animation, removeIndex),
        duration: Duration(milliseconds: 600),
      );
    }
  }
}

class CardWidget extends StatelessWidget {
  final CardData item;
  final double itemWidth;

  const CardWidget(this.item, this.itemWidth, {super.key});

  @override
  Widget build(BuildContext context) {
    double sf = itemWidth / 298;
    return Container(
      width: 288 * sf,
      padding: EdgeInsets.symmetric(horizontal: 11*sf, vertical: 10.h),
      decoration: ShapeDecoration(
        color: Color(0xE5242424),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 30 * sf,
            height: 30.w,
            margin: EdgeInsets.only(right: 8*sf),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.r)),
            ),
            child: SvgPicture.asset("assets/Logo1.svg", fit: BoxFit.contain, width: 10*sf, height: 10.h,clipBehavior: Clip.antiAlias,),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 175*sf,
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
                            color: Color(0xFFC2C2C2),
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
                    children: [
                      SizedBox(
                        width: 177*sf,
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
                        width: 21*sf,
                        height: 21.w,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/no_avatar_image.png"),
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
