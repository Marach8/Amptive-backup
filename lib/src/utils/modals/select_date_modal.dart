import 'dart:typed_data';
import 'dart:ui';

import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../services/create_show/create_show_service.dart';
import '../../views/widgets/common_widgets/custom_container_widget.dart';
import '../../views/widgets/common_widgets/elevated_button_widget.dart';
import '../constants/strings/image_strings.dart';
import '../constants/strings/other_strings.dart';

Future<void> selectDateModal(
    BuildContext context, Uint8List? selectedImage) async {
  CreateShowService service = GetIt.I<CreateShowService>();

  AssetImage? defaultAssetImage =
      const AssetImage(ATImgStrings.createShowPlaceholderImage);
  var now = DateTime.now();

  DateTime selectedDateTime =
      service.isValidEventDateTime() ? service.eventDateTime! : now;

  return await showModalBottomSheet(
      backgroundColor: ATColors.trspntColor,
      constraints: BoxConstraints.expand(
          height: ATHelperFuncs.getScreenHeight(context)),
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: selectedImage != null
                  ? Image.memory(
                      selectedImage,
                      fit: BoxFit.cover,
                    )
                  : Image(
                      image: defaultAssetImage,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned.fill(
              child: Container(
                color: ATColors.black.withOpacity(0.6),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 150.0, sigmaY: 150.0),
                  child: Container(),
                ),
              ),
            ),
            Positioned(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const BackButton(),
                      Padding(
                        padding: EdgeInsets.only(left: 60.w, top: 4.h),
                        child: Text(
                          "Schedule your Event",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 350.w,
                    padding:
                        EdgeInsets.only(left: 7.w, top: 30.h, bottom: 24.h),
                    child: Text(
                      "Please select time between three months from today, and one hour from now",
                      maxLines: null,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ATColors.hexC2C2C2,
                          overflow: TextOverflow.visible),
                    ),
                  ),
                  SizedBox(
                    height: 150.h,
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                        brightness: Brightness.dark,
                      ),
                      child: CupertinoDatePicker(
                        minimumDate: now,
                        initialDateTime: selectedDateTime,
                        mode: CupertinoDatePickerMode.dateAndTime,
                        onDateTimeChanged: (DateTime dateTime) {
                          selectedDateTime = dateTime;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 70.h,
              right: 0,
              child: ATContainer(
                height: 50.h,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: ATHelperFuncs.getScreenWidth(context),
                child: AmptiveElevatedButtonWidget(
                  margin: EdgeInsets.zero,
                  onPressed: () async {
                    service.eventDateTime = selectedDateTime;
                    Navigator.pop(context);
                  },
                  buttonTitle: ATStrings.CONTINUE,
                  bgColor: ATColors.white,
                  fgColor: ATColors.black,
                ),
              ),
            ),
            Positioned(
              bottom: 10.h,
              child: ATContainer(
                height: 50.h,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: ATHelperFuncs.getScreenWidth(context),
                child: AmptiveElevatedButtonWidget(
                  margin: EdgeInsets.zero,
                  onPressed: () async {
                    service.eventDateTime = null;
                    Navigator.pop(context);
                  },
                  buttonTitle: ATStrings.REMOVE,
                  bgColor: ATColors.trspntColor,
                  fgColor: ATColors.whiteColor,
                ),
              ),
            )
          ],
        );
      });
}
