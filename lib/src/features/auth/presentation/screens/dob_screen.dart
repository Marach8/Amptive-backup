import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/validator.dart';
import 'package:amptive/src/features/auth/data/models/request/registration_data.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../shared/app_bar_widget.dart';

class AddDOBScreen extends StatefulWidget {
  const AddDOBScreen({super.key});

  @override
  State<AddDOBScreen> createState() => _AddDOBScreenState();
}

class _AddDOBScreenState extends State<AddDOBScreen> with ATValidators {
  final TextEditingController _dobController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDOB;

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(leading: ATBackBtn()),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ATStrings.whatIsYourDateOfBirth,
                  style: context.textTheme.headlineMedium,
                ),
                ATTextFormField(
                  controller: _dobController,
                  maxLines: 1,
                  validator: validateDOB,
                  onTap: () async {
                    final dynamic data = await _selectDOBModal(
                        context: context, initialDate: selectedDOB);
                    if (data != null) {
                      if (context.mounted && data is String) {
                        showAppNotification2(
                            context: context,
                            text: olderThan13Years,
                            type: NotificationType.failure);
                      } else if (data is DateTime) {
                        selectedDOB = data;
                        final String formattedDate =
                            DateFormat('MMMM d y').format(data);
                        _dobController.text = formattedDate;
                      }
                    }
                  },
                  hintText: ATStrings.selectDate,
                  fillColor: ATColors.hex9E9E9E.withValues(alpha: 0.3),
                  prefixIcon: const SizedBox(
                    width: 10,
                  ),
                  readOnly: true,
                  keyboardType: TextInputType.none,
                ),
                Text(
                  ATStrings.users13andOlderWarning,
                  style: context.textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Builder(builder: (BuildContext context) {
          final double bottom = MediaQuery.viewInsetsOf(context).bottom;
          final double bottomPad = bottom > 0 ? 10 : 50;
          return Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, bottomPad),
              child: AnimatedBuilder(
                  animation: _dobController,
                  builder: (_, __) {
                    final bool shouldEnable =
                        _dobController.text.trim().isNotEmpty;
                    return ATPlainElevatedBtn(
                      btnTitle: ATStrings.next,
                      onPressed: shouldEnable
                          ? () {
                              if (_formKey.currentState?.validate() ?? false) {
                                final String formattedDate =
                                    DateFormat('yyyy-MM-dd')
                                        .format(selectedDOB!);
                                RegistrationData().copyWith(dob: formattedDate);
                                context.pushNamed(ATRoutes.addUserNameScreen);
                              }
                            }
                          : null,
                    );
                  }));
        }),
      ),
    );
  }
}

const String olderThan13Years = 'You must be older than 13 years!';
Future<dynamic> _selectDOBModal({
  required BuildContext context,
  DateTime? initialDate,
}) async {
  final DateTime now = DateTime.now();
  final DateTime maxDate = DateTime(now.year - 13, now.month, now.day);

  // 🔥 If initialDate exists and is valid, use it.
  // Otherwise default to maxDate.
  DateTime datePickedByUser =
      (initialDate != null && !initialDate.isAfter(maxDate))
          ? initialDate
          : maxDate;

  return await showModalBottomSheet<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 250,
        child: Column(
          children: <Widget>[
            Container(
              color: ATColors.grey2Color,
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                child: Text(
                  ATStrings.done,
                  style: context.textTheme.bodyMedium,
                ),
                onPressed: () {
                  if (datePickedByUser.isAfter(maxDate)) {
                    context.pop(olderThan13Years);
                    return;
                  }

                  context.pop(datePickedByUser);
                },
              ),
            ),
            Divider(
              color: ATColors.hex0D0D0D,
              height: 0,
              thickness: 1,
            ),
            Expanded(
              child: Container(
                color: ATColors.hex0D0D0D,
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    brightness: Brightness.dark,
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    maximumDate: now,
                    initialDateTime: datePickedByUser,
                    onDateTimeChanged: (DateTime dateTime) {
                      datePickedByUser = dateTime;
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
