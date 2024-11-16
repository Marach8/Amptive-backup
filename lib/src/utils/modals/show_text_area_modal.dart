import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';

import '../../services/create_show/create_show_service.dart';
import '../constants/colors.dart';
import '../constants/strings/other_strings.dart';
import '../helpers/helper_functions/other_functions.dart';

void showTextAreaModal(BuildContext context) {
  CreateShowService service = GetIt.I<CreateShowService>();

  showModalBottomSheet(
    backgroundColor: AmptiveColors.brandBlackColor,
    constraints: BoxConstraints.expand(
        height: AmptiveHelperFunctions.getScreenHeight(context)),
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Column(
        children: [
          Gap(50.h),
          Text(
            "Description",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Gap(20.h),
          Expanded(
            child: TextFormField(
              controller: service.descController,
              maxLines: 100,
              keyboardType: TextInputType.multiline,
              onChanged: (_) {
                print(service.descController.text.length);
                service.descCharactersLength.value =
                    service.descController.text.length;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: "Tell your listeners what your show is about",
                contentPadding: EdgeInsets.all(15.w),
              ),
            ),
          ),
        ],
      );
    },
  );
}
