import 'package:amptive/src/providers/form_providers.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateOfBirthScreen extends StatefulWidget {
  const DateOfBirthScreen({super.key});

  @override
  State<DateOfBirthScreen> createState() => _DateOfBirthScreenState();
}

class _DateOfBirthScreenState extends State<DateOfBirthScreen> {
  final TextEditingController _dobController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late FormProvider _formProvider;
  bool _isBottomSheetOpened = false;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    _formProvider = Provider.of<FormProvider>(context);
    var bottomSheetHeight = 232.h;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AmpColors.brandBlack,
        appBar: BuildAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What is your date of birth?",
                  style: GoogleFonts.inter(
                    color: AmpColors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: () {
                    _selectDate(bottomSheetHeight);
                  },
                  maxLines: 1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.none,
                  cursorColor: AmpColors.brandBlue,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    hintText: "Select Date",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: AmpColors.authHintColor,
                      fontWeight: FontWeight.normal,
                    ),
                    errorStyle: GoogleFonts.inter(
                      color: AmpColors.textRed,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF9E9E9E).withOpacity(0.3),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.w,
                        color: AmpColors.brandBlue,
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.w,
                        color: AmpColors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.sp,
                      color: AmpColors.white),
                ),
              Container(
                height: 20.h,
                margin: EdgeInsets.symmetric(vertical: 11.h),
                child: Text(
                 "Only users 13 and older may use this app",
                  style: GoogleFonts.inter(
                    color: AmpColors.white,
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
                Consumer<FormProvider>(builder: (context, model, _) {
                  return Container(
                    width: 350.w,
                    height: 50.w,
                    margin: EdgeInsets.only(
                        bottom: _isBottomSheetOpened
                            ? bottomSheetHeight + 0.h
                            : 29.h),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (model.isDOBValid) {
                          context.pushNamed(AmptiveRoutes.addUsername);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: model.dob != null
                              ? AmpColors.brandBlue
                              : const Color(0xFF2F2F2F)),
                      child: Text(
                        "Next",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: model.dob != null
                                ? AmpColors.white
                                : const Color(0xFF666666)),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(bottomSheetHeight) async {
    _onBottomSheetOpened();

    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        DateTime tempPickedDate = DateTime.now();
        var now = DateTime.now();
        var maxDate = DateTime(now.year - 13, now.month, now.day);

        return SizedBox(
          height: bottomSheetHeight,
          child: Column(
            children: <Widget>[
              Container(
                color: const Color(0xFF434343),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text(
                        'Done',
                        style: GoogleFonts.inter(
                            color: AmpColors.white,
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
                color: AmpColors.brandBlack,
                height: 0.h,
                thickness: 1.h,
              ),
              Expanded(
                child: Container(
                  color: AmpColors.brandBlack,
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
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text = _formatDate(pickedDate);
      });

      _formProvider.setDOB(_selectedDate);
    }
  }

  void _onBottomSheetClosed() {
    setState(() {
      _isBottomSheetOpened = false;
    });
  }

  void _onBottomSheetOpened() {
    setState(() {
      _isBottomSheetOpened = true;
    });
  }

  String _formatDate(DateTime pickedDate) {
    return "${DateFormat("MMMM", "en_US").format(pickedDate)} ${pickedDate.day} ${pickedDate.year}";
  }
}
