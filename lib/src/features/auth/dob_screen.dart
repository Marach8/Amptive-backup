import 'package:amptive/src/bloc/authentication/general/auth_events.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../bloc/authentication/general/auth_bloc.dart';
import '../../bloc/authentication/general/auth_states.dart';
import '../../views/widgets/common_widgets/app_bar_widget.dart';

class DateOfBirthScreen extends StatefulWidget {
  const DateOfBirthScreen({super.key});

  @override
  State<DateOfBirthScreen> createState() => _DateOfBirthScreenState();
}

class _DateOfBirthScreenState extends State<DateOfBirthScreen> {
  final TextEditingController _dobController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isBottomSheetOpened = false;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    double bottomSheetHeight = 232.h;

    return ATAnnotatedRegion(
      child: Scaffold(
        backgroundColor: ATColors.hex0D0D0D,
        appBar: const ATAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ATStrings.whatIsYourDateOfBirth,
                  style: GoogleFonts.inter(
                    color: ATColors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                    buildWhen: (AmptiveAuthState p, AmptiveAuthState current) {
                  return current is EditDOBAuthState;
                }, builder: (_, AmptiveAuthState state) {
                  state is EditDOBAuthState && state.dob != null
                      ? _dobController.text = _formatDate(state.dob!)
                      : _dobController.clear();

                  return TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    onTap: () {
                      _selectDate(bottomSheetHeight);
                    },
                    maxLines: 1,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.none,
                    cursorColor: ATColors.hex307FE2,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 16.w),
                      hintText: ATStrings.selectDate,
                      hintStyle: GoogleFonts.inter(
                        fontSize: 16.sp,
                        color: ATColors.hexB6B6B6,
                        fontWeight: FontWeight.normal,
                      ),
                      errorStyle: GoogleFonts.inter(
                        color: ATColors.textRedColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                      ),
                      filled: true,
                      fillColor: ATColors.hex9E9E9E.withOpacity(0.3),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.w,
                          color: ATColors.hex307FE2,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.w,
                          color: ATColors.trsprnt,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.sp,
                        color: ATColors.white),
                  );
                }),
                Container(
                  height: 20.h,
                  margin: EdgeInsets.symmetric(vertical: 11.h),
                  child: Text(
                    ATStrings.users13andOlderWarning,
                    style: GoogleFonts.inter(
                      color: ATColors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.sp,
                      height: 0.14,
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 1.h,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.only(
              bottom: _isBottomSheetOpened ? bottomSheetHeight : 16.h),
          child: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
              buildWhen: (AmptiveAuthState prev, AmptiveAuthState curr) => curr is EditDOBAuthState,
              builder: (BuildContext context, AmptiveAuthState state) {
                return AmptiveElevatedButtonWidget(
                  height: 50.w,
                  onPressed: state is EditDOBAuthState && state.dob != null
                      ? () {
                          context.pushNamed(ATRoutes.addUsername);
                        }
                      : null,
                  buttonTitle: ATStrings.NEXT,
                );
              }),
        ),
      ),
    );
  }

  Future<void> _selectDate(bottomSheetHeight) async {
    _onBottomSheetOpened();

    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime tempPickedDate = DateTime.now();
        DateTime now = DateTime.now();
        DateTime maxDate = DateTime(now.year - 13, now.month, now.day);

        return SizedBox(
          height: bottomSheetHeight,
          child: Column(
            children: <Widget>[
              Container(
                color: ATColors.grey2Color,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text(
                        ATStrings.DONE,
                        style: GoogleFonts.inter(
                            color: ATColors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 16.sp),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                color: ATColors.hex0D0D0D,
                height: 0.h,
                thickness: 1.h,
              ),
              Expanded(
                child: Container(
                  color: ATColors.hex0D0D0D,
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      brightness: Brightness.dark,
                    ),
                    child: CupertinoDatePicker(
                      maximumDate: maxDate,
                      initialDateTime: maxDate,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (DateTime dateTime) {
                        tempPickedDate = dateTime;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() => _onBottomSheetClosed());

    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;

      if (mounted) {
        context
            .read<AmptiveAuthBloc>()
            .add(EditDOBAuthEvent(selectedDate: _selectedDate));
      }
    }
  }

  void _onBottomSheetClosed() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isBottomSheetOpened = false;
      });
    });
  }

  void _onBottomSheetOpened() {
    // todo fix bug when setstate is called
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isBottomSheetOpened = true;
      });
    });
  }

  String _formatDate(DateTime pickedDate) {
    return "${DateFormat("MMMM", "en_US").format(pickedDate)} ${pickedDate.day} ${pickedDate.year}";
  }
}
