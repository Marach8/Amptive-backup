import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../config/utils/colors.dart';
import '../../config/utils/other_strings.dart';
import '../../config/routing/route_strings.dart';
import '../../features/auth/cubits/register_user_cubit.dart';
import '../../features/auth/data/models/user_data.dart';
import '../../views/widgets/common_widgets/annotated_region__widget.dart';
import '../../views/widgets/common_widgets/app_bar_widget.dart';
import '../../views/widgets/common_widgets/back_button.dart';
import '../../shared/elevated_button_widget.dart';

class AddDOBScreen extends StatefulWidget {
  const AddDOBScreen({super.key});

  @override
  State<AddDOBScreen> createState() => _AddDOBScreenState();
}

class _AddDOBScreenState extends State<AddDOBScreen> {
  final TextEditingController _dobController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isBottomSheetOpened = false;

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RegisterUserCubit cubit = context.read<RegisterUserCubit>();
    final state = context.watch<RegisterUserCubit>().state;
    final dob = cubit.getCurrentData().dob;
    
    // Sync controller with state
    if (_dobController.text != dob) {
      _dobController.text = dob;
    }

    final double bottomSheetHeight = 232.h;

    return ATAnnotatedRegion(
      child: Scaffold(
        backgroundColor: ATColors.hex0D0D0D,
        appBar: const ATAppBar(leading: ATBackBtn()),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ATStrings.whatIsYourDateOfBirth,
                  style: GoogleFonts.inter(
                    color: ATColors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 11.h),
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: () => _selectDate(bottomSheetHeight, cubit),
                  maxLines: 1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.none,
                  cursorColor: ATColors.hex307FE2,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 16.w,
                    ),
                    hintText: ATStrings.selectDate,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: ATColors.hexB6B6B6,
                    ),
                    filled: true,
                    fillColor: ATColors.hex9E9E9E.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(
                        color: ATColors.hex307FE2,
                        width: 2.w,
                      ),
                    ),
                  ),
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: ATColors.white,
                  ),
                ),
                SizedBox(height: 11.h),
                Text(
                  ATStrings.users13andOlderWarning,
                  style: GoogleFonts.inter(
                    color: ATColors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(15),
          child: ATPlainElevatedBtn(
            btnTitle: ATStrings.next,
            onPressed: dob.isNotEmpty
                ? () => context.pushNamed(ATRoutes.ADD_USERNAME_AUTH_SCREEN)
                : null,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(
      double bottomSheetHeight, RegisterUserCubit cubit) async {
    _onBottomSheetOpened();

    final now = DateTime.now();
    final maxDate = DateTime(now.year - 13, now.month, now.day);
    DateTime tempPickedDate = maxDate;

    final pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (_) {
        return SizedBox(
          height: bottomSheetHeight,
          child: Column(
            children: [
              Container(
                color: ATColors.grey2Color,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      child: Text(
                        ATStrings.DONE,
                        style: GoogleFonts.inter(
                          color: ATColors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      onPressed: () =>
                          Navigator.of(context).pop(tempPickedDate),
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
                    data: const CupertinoThemeData(brightness: Brightness.dark),
                    child: CupertinoDatePicker(
                      maximumDate: maxDate,
                      initialDateTime: maxDate,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (dateTime) =>
                          tempPickedDate = dateTime,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() => _onBottomSheetClosed());

    if (pickedDate != null) {
      cubit.setDob(_formatDate(pickedDate));
    }
  }

  void _onBottomSheetClosed() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() => _isBottomSheetOpened = false),
    );
  }

  void _onBottomSheetOpened() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() => _isBottomSheetOpened = true),
    );
  }

  String _formatDate(DateTime date) => 
    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }