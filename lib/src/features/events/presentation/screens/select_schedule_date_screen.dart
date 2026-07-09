import 'dart:typed_data';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dominant_color_extractor.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/mesh_gradient_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// What the schedule screen hands back to the form. `null` from the route
/// means the user cancelled (backed out) and nothing should change.
class ScheduleDateResult {
  const ScheduleDateResult.selected(DateTime this.date) : removed = false;
  const ScheduleDateResult.removed()
      : date = null,
        removed = true;

  final DateTime? date;
  final bool removed;
}

class SelectScheduleDataScreenEntryParams {
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
  State<SelectScheduleDateScreen> createState() =>
      _SelectScheduleDateScreenState();
}

class _SelectScheduleDateScreenState extends State<SelectScheduleDateScreen> {
  DateTime? _selectedDateTime;
  final DominantColorCubit _colorCubit = DominantColorCubit();

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    final DateTime minDate = now.add(const Duration(hours: 1));
    final DateTime maxDate = now.add(const Duration(days: 90));

    final DateTime? incomingDate = widget.params.incomingDate;
    if (incomingDate != null &&
        !incomingDate.isBefore(minDate) &&
        !incomingDate.isAfter(maxDate)) {
      _selectedDateTime = incomingDate;
    }

    // Tint the mesh from the cover, like the create form.
    if (widget.params.selectedBgImage != null) {
      _colorCubit.extractColorFromBytes(widget.params.selectedBgImage!);
    } else {
      _colorCubit.extractColor(widget.params.incomingBgImageUrl ??
          ATImgStrings.createShowPlaceholder);
    }
  }

  @override
  void dispose() {
    _colorCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final double topPadding = MediaQuery.paddingOf(context).top;

    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: BlocBuilder<DominantColorCubit, DominantColorState>(
          bloc: _colorCubit,
          builder: (_, DominantColorState colorState) {
            return ATMeshGradientBackground(
              state: colorState,
              child: Column(
                children: <Widget>[
                  // Header — matches the create-episode header: status bar +
                  // a toolbar row with the back arrow and a centered title.
                  SizedBox(height: topPadding),
                  SizedBox(
                    height: kToolbarHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 7),
                          child: ATBackBtn(),
                        ),
                        Text(
                          'Schedule your '
                          '${widget.params.programName.toLowerCase()}',
                          style: context.textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 44),
                      ],
                    ),
                  ),
                  // Subtext sits directly under the header, left aligned.
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Please select a time between one hour from now '
                        'and three months from today.',
                        textAlign: TextAlign.left,
                        maxLines: 5,
                        style: context.textTheme.labelSmall!.copyWith(
                          color: ATColors.hexC2C2C2.withValues(alpha: 0.76),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  // Picker sits just under the subtext; buttons pinned below.
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: SizedBox(
                          height: 200,
                          width: MediaQuery.sizeOf(context).width * 0.86,
                          child: CupertinoTheme(
                            data: const CupertinoThemeData(
                              brightness: Brightness.dark,
                            ),
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.dateAndTime,
                              use24hFormat: true,
                              // Widen the highlight band (no side inset) but keep
                              // the rounded outer corners of the iOS look by
                              // rounding only the first/last columns.
                              selectionOverlayBuilder: (
                                BuildContext context, {
                                required int columnCount,
                                required int selectedIndex,
                              }) {
                                final bool isFirst = selectedIndex == 0;
                                final bool isLast =
                                    selectedIndex == columnCount - 1;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.tertiarySystemFill,
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(isFirst ? 12 : 0),
                                      right: Radius.circular(isLast ? 12 : 0),
                                    ),
                                  ),
                                );
                              },
                              minimumDate: now.add(const Duration(hours: 1)),
                              maximumDate: now.add(const Duration(days: 90)),
                              initialDateTime: _selectedDateTime ??
                                  now.add(const Duration(hours: 1)),
                              onDateTimeChanged: (DateTime dateTime) {
                                _selectedDateTime = dateTime;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 14),
                    child: ATPlainElevatedBtn(
                        fgColor: ATColors.black,
                        bgColor: ATColors.white,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: ATColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        onPressed: () => context.pop(
                            ScheduleDateResult.selected(_selectedDateTime ??
                                now.add(const Duration(hours: 1)))),
                        btnTitle: ATStrings.cContinue),
                  ),
                  // Remove clears any existing schedule and closes the screen.
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () =>
                        context.pop(const ScheduleDateResult.removed()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(ATStrings.remove,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 17,
                            color: ATColors.hexC2C2C2.withValues(alpha: 0.85),
                          )),
                    ),
                  ),
                  SizedBox(height: MediaQuery.paddingOf(context).bottom + 12),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
