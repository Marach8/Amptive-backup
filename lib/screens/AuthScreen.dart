import 'package:amptive/routers/amptive_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/common_widgets.dart';
import '../utils/utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.isLogin});

  final bool isLogin;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = false;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: BuildAppBar(
          titleWidget: Container(
            margin: EdgeInsets.symmetric(vertical: 12.55.h),
            child: SvgPicture.asset(
              "assets/amptive_logotype.svg",
              semanticsLabel: 'Amptive Logo',
            ),
          ),
        ),
        backgroundColor: AmpColors.brandBlack,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          margin: EdgeInsets.only(top: 141.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 18.h,
              ),
              SizedBox(
                height: 48.h,
                child: TextButton(
                  onPressed: () {
                    if (!_isLogin) {
                      //sign up
                      context.pushNamed(AmptiveRoutes.emailAuth);
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AmpColors.white,
                    backgroundColor: AmpColors.brandBlue,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100.h)),
                    ),
                  ),
                  child: Text(
                    _isLogin ? "Sign in with Email" : "Sign up with Email",
                    style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.26.sp),
                  ),
                ),
              ),
              SizedBox(
                height: 18.h,
              ),
              SizedBox(
                height: 48.h,
                child: TextButton(
                  onPressed: () {
                    context.pushNamed(AmptiveRoutes.addPhone);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AmpColors.white,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: AmpColors.strokeGray, width: 1.h),
                      borderRadius: BorderRadius.all(Radius.circular(100.h)),
                    ),
                  ),
                  child: Text(
                    _isLogin
                        ? "Sign in with Phone Number"
                        : "Sign up with Phone Number",
                    style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.26.sp),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 37.h,
                margin: EdgeInsets.symmetric(vertical: 17.h),
                child: Text(
                  "or",
                  style: GoogleFonts.inter(
                      color: AmpColors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.26.sp),
                ),
              ),
              BrandButton(
                isLogin: _isLogin,
                brand: "Facebook",
                image: Image.asset(
                  "assets/facebook.png",
                  scale: 22.5.h,
                ),
              ),
              SizedBox(
                height: 17.h,
              ),
              BrandButton(
                isLogin: _isLogin,
                brand: "X(Twitter)",
                image: Icon(
                  FontAwesomeIcons.xTwitter,
                  size: 22.5.h,
                ),
              ),
              SizedBox(
                height: 17.h,
              ),
              BrandButton(
                isLogin: _isLogin,
                brand: "Google",
                image: Image.asset(
                  'assets/google_icon.png',
                  scale: 22.5.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class BrandButton extends StatelessWidget {
  const BrandButton({
    super.key,
    required bool isLogin,
    required this.brand,
    required this.image,
  }) : _isLogin = isLogin;

  final bool _isLogin;
  final String brand;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: TextButton.icon(
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: AmpColors.white,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AmpColors.strokeGray, width: 1.h),
            borderRadius: BorderRadius.all(Radius.circular(100.h)),
          ),
        ),
        icon: Padding(
          padding: EdgeInsets.only(left: 13.w),
          child: image,
        ),
        label: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 39.5.w),
          child: Text(
            _isLogin ? "Sign in with $brand" : "Sign up with $brand",
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
