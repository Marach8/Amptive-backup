import 'dart:ui';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SelectScheduleDataScreenEntryParams{
  SelectScheduleDataScreenEntryParams({
    this.selectedBgImage,
    required this.programName,
    this.incomingDate,
    this.incomingBgImageUrl,
  });

  final Uint8List? selectedBgImage;
  final String programName;
  final DateTime? incomingDate;
  final String? incomingBgImageUrl;
}


class SelectScheduleDateScreen extends StatefulWidget {
  const SelectScheduleDateScreen({
    super.key,
    required this.params,
  });

  final SelectScheduleDataScreenEntryParams params;

  @override
  State<SelectScheduleDateScreen> createState() => _SelectScheduleDateScreenState();
}

class _SelectScheduleDateScreenState extends State<SelectScheduleDateScreen> {
  DateTime? _selectedDateTime;

  @override 
  void initState(){
    super.initState();
    final DateTime now = DateTime.now();
    final DateTime minDate = now.add(const Duration(hours: 1));
    final DateTime maxDate = now.add(const Duration(days: 90));

    final DateTime? incomingDate = widget.params.incomingDate;

    if (incomingDate != null &&
        !incomingDate.isBefore(minDate) &&
        !incomingDate.isAfter(maxDate)) {
      _selectedDateTime = incomingDate;
    } else {
      _selectedDateTime = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: widget.params.selectedBgImage == null ? ATImgLoader(
                  boxFit: BoxFit.fill,
                  imgPath: widget.params.incomingBgImageUrl ??
                    ATImgStrings.createShowPlaceholder,
                ) : Image.memory(widget.params.selectedBgImage!, fit: BoxFit.fill),
              ),
            ),

            Container(
              color: ATColors.hex0D0D0D.withValues(alpha: 0.85),
              padding: const EdgeInsets.only(top: kToolbarHeight),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 7),
                        child: ATRoundedBackBtn()),
                      Text(
                        'Schedule your ${widget.params.programName.toLowerCase()}',
                        style: context.textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 30,)
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Please, select time between three months from today, and one hour from now',
                              maxLines: 5,
                              style: context.textTheme.labelSmall!.copyWith(
                                color: ATColors.hexC2C2C2
                                  .withValues(alpha: 0.76)),
                            ),
                          ),
                          SizedBox(
                            height: 150,
                            child: CupertinoTheme(
                              data: const CupertinoThemeData(
                                brightness: Brightness.dark,
                              ),
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.dateAndTime,
                                minimumDate: now.add(const Duration(hours: 1)),
                                maximumDate: now.add(const Duration(days: 90)),
                                initialDateTime: _selectedDateTime ??
                                    now.add(const Duration(hours: 1)),
                                onDateTimeChanged: (DateTime dateTime) {
                                  _selectedDateTime = dateTime;
                                },
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                    child: ATPlainElevatedBtn(
                      fgColor: ATColors.black,
                      bgColor: ATColors.white,
                      onPressed: (){
                        context.pop(_selectedDateTime);
                      },
                      btnTitle: ATStrings.cContinue
                    ),
                  ),

                  InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: (){
                      setState(() {
                        _selectedDateTime = null;
                      });
                    },
                    child: Text(
                      ATStrings.remove,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 17
                      )
                    ),
                  ),
                  const SizedBox(height: 60,)
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
