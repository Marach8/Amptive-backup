import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/validator.dart';
import 'package:amptive/src/features/auth/data/models/request/registration_data.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
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
            physics: const NeverScrollableScrollPhysics(),
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
                      bgColor: Colors.white,
                      fgColor: Colors.black,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
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

  DateTime datePickedByUser =
      (initialDate != null && !initialDate.isAfter(maxDate))
          ? initialDate
          : maxDate;

  return await showCupertinoModalPopup<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: ATColors.black,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: <Widget>[
              // Authentic iOS Toolbar
              Container(
                decoration: BoxDecoration(
                  color: ATColors.grey2Color.withValues(alpha: 0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: const Text(
                        ATStrings.done,
                        style: TextStyle(
                          color: CupertinoColors.activeBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        if (datePickedByUser.isAfter(maxDate)) {
                          Navigator.of(context).pop(olderThan13Years);
                          return;
                        }
                        Navigator.of(context).pop(datePickedByUser);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
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
            ],
          ),
        ),
      );
    },
  );
}
