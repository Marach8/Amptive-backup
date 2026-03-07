import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:amptive/src/shared/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/app_bar_widget.dart';
import '../../../../shared/back_button.dart';

class ATSelectLanguageScreen extends StatelessWidget {
  const ATSelectLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String selectedLanguge = _languages.first;
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(
          leadingWidth: 30,
          padding: EdgeInsets.only(left: 7),
          leading: ATRoundedBackBtn(),
          titleText: ATStrings.language,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 50),
          child: StatefulBuilder(builder: (_, StateSetter setter) {
            return ATContainer(
              onTap: () {
                _showAvailableLanguagesModal(
                  context: context,
                  selectedLanguage: selectedLanguge,
                ).then((String? lang) {
                  if (lang != null) {
                    setter(() {
                      selectedLanguge = lang;
                    });
                  }
                });
              },
              color: ATColors.white.withValues(alpha: 0.1),
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              radius: 14,
              child: Row(
                children: <Widget>[
                  Text(
                    ATStrings.appLanguage,
                    style: context.textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    selectedLanguge,
                    style: context.textTheme.bodySmall?.copyWith(
                        color: ATColors.white.withValues(alpha: 0.4)),
                  ),
                  Icon(Icons.keyboard_arrow_right,
                      size: 20, color: ATColors.white.withValues(alpha: 0.4)),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

final List<String> _languages = <String>['English', 'China', 'Francais'];

Future<String?> _showAvailableLanguagesModal({
  required BuildContext context,
  required String selectedLanguage,
}) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: ATColors.hex202020,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    builder: (BuildContext dContext) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          const ATModalDismisser(),
          Column(
              mainAxisSize: MainAxisSize.min,
              children: _languages.map((String lang) {
                final bool isSelected = lang == selectedLanguage;
                return ATContainer(
                  onTap: () {
                    dContext.pop(lang);
                  },
                  margin: const EdgeInsets.all(15),
                  radius: 0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(lang, style: context.textTheme.titleMedium),
                      ),
                      ATRadioBtn(isSelected: isSelected)
                    ],
                  ),
                );
              }).toList()),
          const SizedBox(
            height: 60,
          )
        ],
      );
    },
  );
}
