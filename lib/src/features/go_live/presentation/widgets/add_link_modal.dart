import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';

Future<(String, String)?> addLinkModal({
  required BuildContext context,
  String? linkName,
  String? linkUrl,
}) async {
  return await showModalBottomSheet<(String, String)>(
      backgroundColor: ATColors.hex202020,
      constraints: BoxConstraints(
          maxHeight: context.screenHeight, maxWidth: context.screenWidth),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      isScrollControlled: true,
      elevation: 0,
      builder: (_) => _AddLinkWidget(
            linkName: linkName,
            linkUrl: linkUrl,
          ));
}

class _AddLinkWidget extends StatefulWidget {
  const _AddLinkWidget({this.linkName, this.linkUrl});

  final String? linkName, linkUrl;

  @override
  State<_AddLinkWidget> createState() => _AddLinkWidgetState();
}

class _AddLinkWidgetState extends State<_AddLinkWidget> with ATValidators {
  late final TextEditingController _linkNameCntrl, _linkUrlCntrl;
  late final ValueNotifier<bool> _activateBtn;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _linkNameCntrl = TextEditingController(text: widget.linkName)
      ..addListener(_handleBtnActivation);

    _linkUrlCntrl = TextEditingController(text: widget.linkUrl)
      ..addListener(_handleBtnActivation);

    _activateBtn =
        ValueNotifier<bool>(widget.linkName != null && widget.linkUrl != null);
  }

  void _handleBtnActivation() =>
      _activateBtn.value = _linkNameCntrl.text.trim().isNotEmpty &&
          _linkUrlCntrl.text.trim().isNotEmpty;

  @override
  void dispose() {
    _linkNameCntrl.dispose();
    _linkUrlCntrl.dispose();
    _activateBtn.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
          15, 15, 15, MediaQuery.viewInsetsOf(context).bottom + 40),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const ATModalDismisser(),
            const SizedBox(
              height: 10,
            ),
            Text(
              ATStrings.ADD_LINK,
              style: context.textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ATStrings.TEXT,
                style: context.textTheme.bodySmall
                    ?.copyWith(fontSize: ATSizes.size15),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ATTextFormField(
              disableBlueBorder: true,
              controller: _linkNameCntrl,
              prefixIcon: const SizedBox(
                width: 15,
              ),
              cursorHeight: 20,
              hintText: ATStrings.LINK_NAME,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: ATColors.transparent)),
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ATStrings.LINK,
                style: context.textTheme.bodySmall
                    ?.copyWith(fontSize: ATSizes.size15),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ATTextFormField(
              disableBlueBorder: true,
              controller: _linkUrlCntrl,
              cursorHeight: 20,
              validator: validateUrl,
              prefixIcon: const SizedBox(
                width: 15,
              ),
              hintText: ATStrings.LINK_URL,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: ATColors.transparent)),
            ),
            const SizedBox(
              height: 50,
            ),
            ValueListenableBuilder<bool>(
                valueListenable: _activateBtn,
                builder: (_, bool shouldActivate, __) {
                  return ATPlainElevatedBtn(
                    onPressed: shouldActivate
                        ? () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.pop((
                                _linkNameCntrl.text.trim(),
                                _linkUrlCntrl.text.trim()
                              ));
                            }
                          }
                        : null,
                    btnTitle: ATStrings.ADD_LINK.toLowerCase().capitalize,
                    fgColor: ATColors.black,
                    bgColor: ATColors.white,
                  );
                })
          ],
        ),
      ),
    );
  }
}

