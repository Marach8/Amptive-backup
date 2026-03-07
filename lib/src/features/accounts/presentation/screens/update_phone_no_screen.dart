import 'dart:async' show StreamController;

import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/cupertino_country_picker.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpdatePhoneNoScreen extends StatefulWidget {
  const UpdatePhoneNoScreen({super.key, required this.title});
  final String title;

  @override
  State<UpdatePhoneNoScreen> createState() => _UpdatePhoneNoScreenState();
}

class _UpdatePhoneNoScreenState extends State<UpdatePhoneNoScreen> {
  bool _bottomSheetOpened = false;
  final TextEditingController _controller = TextEditingController();
  final StreamController<bool> _activateButtonCntrl = StreamController<bool>();
  Country selectedCountry = CountryPickerUtils.getCountryByIsoCode('NG');

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      ATHelperFuncs.callDebouncer(500,
          () => _activateButtonCntrl.add(_controller.text.trim().length >= 7));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _activateButtonCntrl.close();
    ATHelperFuncs.disposeDebouncer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          leadingWidth: 30,
          padding: const EdgeInsets.only(left: 7),
          leading: const ATRoundedBackBtn(),
          titleText: widget.title,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                ATStrings.UR_FON_NUMBER,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: ATSizes.size17,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  StatefulBuilder(
                      builder: (_, void Function(void Function()) setter) {
                    return ATContainer(
                      onTap: () async {
                        setter(() {
                          _bottomSheetOpened = true;
                        });
                        final Country? newSelectedCountry =
                            await showCupertinoCountryPickerModal(
                          context: context,
                          initialCountry: selectedCountry,
                        );
                        setter(() {
                          _bottomSheetOpened = false;
                          if (newSelectedCountry != null) {
                            selectedCountry = newSelectedCountry;
                          }
                        });
                      },
                      padding: const EdgeInsets.fromLTRB(16, 9, 16, 9),
                      color: ATColors.white.withValues(alpha: 0.1),
                      radius: 14,
                      border: Border.all(
                        color: _bottomSheetOpened
                            ? ATColors.hex307FE2
                            : ATColors.transparent,
                        width: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 13,
                            width: 17,
                            child: ATImgLoader(
                              imgPath: CountryPickerUtils.getFlagImageAssetPath(
                                  selectedCountry.isoCode),
                              boxFit: BoxFit.fill,
                              package: ATStrings.countryPickers,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ATStrings.plus + selectedCountry.phoneCode,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: ATColors.white),
                          ),
                          Icon(
                            _bottomSheetOpened
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ATTextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      cursorColor: ATColors.hex307FE2,
                      prefixIcon: const SizedBox(
                        width: 10,
                      ),
                      hintText: ATStrings.phoneNumber,
                    ),
                  ),
                ],
              ),
              Text(
                ATStrings.no_will_be_verified,
                style: context.textTheme.titleSmall?.copyWith(
                  height: 1.5,
                  fontSize: ATSizes.size11,
                ),
              )
            ],
          ),
        ),
        bottomSheet: Builder(
          builder: (BuildContext context) {
            final double bottom = MediaQuery.viewInsetsOf(context).bottom;
            final double bottomPadding = bottom == 0 ? 60 : 15;

            return Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, bottomPadding),
              child: StreamBuilder<bool>(
                stream: _activateButtonCntrl.stream,
                builder: (_, AsyncSnapshot<bool> snapshot) {
                  final bool isActive =
                      snapshot.hasData && snapshot.data == true;

                  return ATPlainElevatedBtn(
                    onPressed: isActive
                        ? () async {
                            final String? newPhoneNumber = await context
                                .pushNamed(ATRoutes.ENTER_OTP_SCREEN,
                                    extra: <String>[
                                  '+${selectedCountry.phoneCode} ${_controller.text.trim()}',
                                  widget.title
                                ]);
                            if (context.mounted && newPhoneNumber != null) {
                              context.pop(newPhoneNumber);
                            }
                          }
                        : null,
                    btnTitle: 'Verify Phone Number',
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
